import asyncio
import json
import logging
import time

import aiomqtt

log = logging.getLogger(__name__)

_BROKER = "mqtt.samora.lan"
_PORT = 1883

# Rate-limiting thresholds
_TEMP_DELTA = 0.5   # °C
_AROMA_DELTA = 1.0  # mL
_PERIODIC_S = 30.0  # publish at least this often regardless of change

_DEVICE = {
    "identifiers": ["sauna_ctrl"],
    "name": "Sauna Controller",
    "model": "RPi + LabVIEW RT",
}
_AVAIL = {"topic": "sauna_ctrl/availability"}


class MQTTBridge:
    def __init__(self, state, display, ws_to_lv: asyncio.Queue):
        self._state = state
        self._display = display
        self._ws_to_lv = ws_to_lv
        self._client: aiomqtt.Client | None = None

        # Rate-limiting: (last_value, last_publish_monotonic)
        self._rl: dict = {
            "ceiling_temp": (None, 0.0),
            "heater_temp":  (None, 0.0),
            "aroma_level":  (None, 0.0),
        }
        # Last published state for binary sensors
        self._bin: dict = {
            "water_spray": None,
            "aroma_pump":  None,
            "door_closed": None,
        }

    # ------------------------------------------------------------------ #
    # Callbacks invoked by ws_server                                       #
    # ------------------------------------------------------------------ #

    async def on_sensors(self, msg: dict):
        client = self._client
        if client is None:
            return

        now = time.monotonic()

        # Continuous sensors — rate-limited
        for key, topic, delta in (
            ("ceiling_temp", "SaunaControl/ceiling_temp", _TEMP_DELTA),
            ("heater_temp",  "SaunaControl/heater_temp",  _TEMP_DELTA),
            ("aroma_level",  "SaunaControl/aroma_level",  _AROMA_DELTA),
        ):
            val = msg.get(key)
            if val is None:
                continue
            prev_val, prev_t = self._rl[key]
            if (
                prev_val is None
                or abs(val - prev_val) >= delta
                or (now - prev_t) >= _PERIODIC_S
            ):
                await client.publish(topic, f"{val:.1f}", qos=1)
                self._rl[key] = (val, now)

        # Binary sensors — publish immediately on change
        binary = (
            ("water_spray", "SaunaControl/water_spray", lambda v: "ON" if v else "OFF"),
            ("aroma_pump",  "SaunaControl/aroma_pump",  lambda v: "ON" if v else "OFF"),
            ("door_closed", "SaunaControl/door",        lambda v: "OFF" if v else "ON"),  # ON = open
        )
        for key, topic, fmt in binary:
            val = msg.get(key)
            if val is None:
                continue
            if val != self._bin[key]:
                await client.publish(topic, fmt(val), qos=1)
                self._bin[key] = val

        # Update display
        ceiling = msg.get("ceiling_temp")
        aroma = msg.get("aroma_level")
        if ceiling is not None:
            self._display.update_temp(ceiling)
        if aroma is not None:
            self._display.update_aroma(aroma)

    async def on_power_btn(self):
        client = self._client
        if client:
            await client.publish("sauna_ctrl/power_btn/action", "power_btn_pressed", qos=1)

    async def on_ws_connect(self):
        client = self._client
        if client:
            await client.publish("sauna_ctrl/availability", "online", qos=1, retain=True)

    async def on_ws_disconnect(self):
        client = self._client
        if client:
            await client.publish("sauna_ctrl/availability", "offline", qos=1, retain=True)

    async def publish_button(self, key: str):
        client = self._client
        if client:
            await client.publish(
                f"sauna_ctrl/sauna_ctrl_{key}/action", f"{key}_pressed", qos=1
            )

    # ------------------------------------------------------------------ #
    # Main task                                                            #
    # ------------------------------------------------------------------ #

    async def run(self):
        while True:
            try:
                await self._connect()
            except aiomqtt.MqttError as exc:
                log.warning("MQTT error: %s — reconnecting in 5 s", exc)
                self._client = None
                await asyncio.sleep(5)

    async def _connect(self):
        will = aiomqtt.Will(
            topic="sauna_ctrl/availability",
            payload="offline",
            qos=1,
            retain=True,
        )
        async with aiomqtt.Client(_BROKER, port=_PORT, will=will) as client:
            self._client = client
            log.info("MQTT connected to %s:%d", _BROKER, _PORT)

            await self._publish_discovery(client)
            await client.subscribe("zigbee2mqtt/Sauna Power")
            await client.subscribe("SaunaControl/zero_adjust/press")

            # If LabVIEW RT was already connected before MQTT reconnected, go online
            if self._state.ws_connected:
                await client.publish("sauna_ctrl/availability", "online", qos=1, retain=True)

            async for message in client.messages:
                await self._handle(message)

    async def _handle(self, message):
        topic = str(message.topic)
        payload = message.payload.decode()

        if topic == "zigbee2mqtt/Sauna Power":
            try:
                on = json.loads(payload).get("state", "").upper() == "ON"
            except (json.JSONDecodeError, AttributeError):
                on = payload.strip().upper() == "ON"
            self._state.power_on = on
            self._display.update_power(on)
            self._ws_to_lv.put_nowait({"type": "power_indicator", "state": on})

        elif topic == "SaunaControl/zero_adjust/press":
            self._ws_to_lv.put_nowait({"type": "zero_adjust"})

    # ------------------------------------------------------------------ #
    # HA discovery                                                         #
    # ------------------------------------------------------------------ #

    async def _publish_discovery(self, client: aiomqtt.Client):
        sensors = [
            ("sauna_ceiling_temp", "Sauna Ceiling Temperature",
             "SaunaControl/ceiling_temp", "temperature", "°C"),
            ("sauna_heater_temp",  "Sauna Heater Temperature",
             "SaunaControl/heater_temp",  "temperature", "°C"),
            ("sauna_aroma_level",  "Sauna Aroma Level",
             "SaunaControl/aroma_level",  None,           "mL"),
        ]
        for obj_id, name, state_topic, dev_class, unit in sensors:
            cfg: dict = {
                "name": name,
                "state_topic": state_topic,
                "unique_id": obj_id,
                "device": _DEVICE,
                "availability": [_AVAIL],
                "expire_after": 60,
                "unit_of_measurement": unit,
            }
            if dev_class:
                cfg["device_class"] = dev_class
            await client.publish(
                f"homeassistant/sensor/{obj_id}/config",
                json.dumps(cfg), qos=1, retain=True,
            )

        binary_sensors = [
            ("sauna_water_spray", "Sauna Water Spray", "SaunaControl/water_spray", "running"),
            ("sauna_aroma_pump",  "Sauna Aroma Pump",  "SaunaControl/aroma_pump",  "running"),
            ("sauna_door",        "Sauna Door",        "SaunaControl/door",         "door"),
        ]
        for obj_id, name, state_topic, dev_class in binary_sensors:
            await client.publish(
                f"homeassistant/binary_sensor/{obj_id}/config",
                json.dumps({
                    "name": name,
                    "state_topic": state_topic,
                    "unique_id": obj_id,
                    "device": _DEVICE,
                    "availability": [_AVAIL],
                    "device_class": dev_class,
                    "expire_after": 60,
                    "payload_on": "ON",
                    "payload_off": "OFF",
                }),
                qos=1, retain=True,
            )

        # Zero-adjust button
        await client.publish(
            "homeassistant/button/sauna_zero_adjust/config",
            json.dumps({
                "name": "Sauna Aroma Zero Adjust",
                "command_topic": "SaunaControl/zero_adjust/press",
                "unique_id": "sauna_zero_adjust",
                "device": _DEVICE,
                "availability": [_AVAIL],
            }),
            qos=1, retain=True,
        )

        # Power button device automation
        await client.publish(
            "homeassistant/device_automation/sauna_power_btn/action_power_btn_press/config",
            json.dumps({
                "automation_type": "trigger",
                "type": "action",
                "subtype": "power_btn_pressed",
                "payload": "power_btn_pressed",
                "topic": "sauna_ctrl/power_btn/action",
                "device": _DEVICE,
            }),
            qos=1, retain=True,
        )

        # RPi GPIO button device automations
        for key in ("key_u", "key_d", "key_l", "key_r", "key_p", "key1", "key2", "key3"):
            label = f"{key}_pressed"
            await client.publish(
                f"homeassistant/device_automation/sauna_ctrl_{key}/action_{key}_press/config",
                json.dumps({
                    "automation_type": "trigger",
                    "type": "action",
                    "subtype": label,
                    "payload": label,
                    "topic": f"sauna_ctrl/sauna_ctrl_{key}/action",
                    "device": _DEVICE,
                }),
                qos=1, retain=True,
            )

        log.info("HA discovery published")
