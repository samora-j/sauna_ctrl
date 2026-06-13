import asyncio
import json
import logging
import time

import aiomqtt

log = logging.getLogger(__name__)

_BROKER = "mqtt.samora.lan"
_PORT = 1883

_TEMP_DELTA = 0.5
_AROMA_DELTA = 1.0
_PERIODIC_S = 30.0

_DEVICE = {
    "identifiers": ["sauna_ctrl"],
    "name": "Sauna Controller",
    "model": "RPi + sbRIO-9642",
}
_AVAIL = {"topic": "sauna_ctrl/availability"}

_ACTUATOR_DEFAULTS = {
    "Kiuas_Button_LED":     False,
    "Loyly_Button_LED":     False,
    "Loyly_Valve_Enable":   False,
    "Loyly_Valve":          False,
    "Aromi_Button_LED":     False,
    "Aromi_Pump_Enable":    False,
    "Aromi_Pump":           False,
    "Aromi_Pump_Direction": False,
    "Aromi_Pump_Cycle":     0,
}


class MQTTBridge:
    def __init__(self, state, display, ws_to_sbrio: asyncio.Queue):
        self._state = state
        self._display = display
        self._ws_to_sbrio = ws_to_sbrio
        self._client: aiomqtt.Client | None = None
        self._actuators = dict(_ACTUATOR_DEFAULTS)

        self._rl: dict = {
            "Ceiling_Temp": (None, 0.0),
            "Kiuas_Temp":   (None, 0.0),
            "Aromi_Volume": (None, 0.0),
        }
        self._bin: dict = {"door": None, "kiuas_button": None}

    # ------------------------------------------------------------------ #
    # Callbacks invoked by ws_client                                       #
    # ------------------------------------------------------------------ #

    async def on_sensors(self, msg: dict):
        client = self._client
        if client is None:
            return

        now = time.monotonic()

        for key, topic, delta in (
            ("Ceiling_Temp", "SaunaControl/ceiling_temp", _TEMP_DELTA),
            ("Kiuas_Temp",   "SaunaControl/kiuas_temp",   _TEMP_DELTA),
            ("Aromi_Volume", "SaunaControl/aromi_volume", _AROMA_DELTA),
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

        kiuas_btn = msg.get("Kiuas_Button")
        if kiuas_btn is not None:
            if kiuas_btn and self._bin["kiuas_button"] is False:
                await client.publish("sauna_ctrl/power_btn/action", "power_btn_pressed", qos=1)
            self._bin["kiuas_button"] = kiuas_btn

        door = msg.get("Door")
        if door is not None and door != self._bin["door"]:
            # Door=true → open → HA ON; Door=false → closed → HA OFF
            await client.publish(
                "SaunaControl/door", "ON" if door else "OFF", qos=1
            )
            self._bin["door"] = door

        ceiling = msg.get("Ceiling_Temp")
        aromi = msg.get("Aromi_Volume")
        if ceiling is not None:
            self._display.update_temp(ceiling)
        if aromi is not None:
            self._display.update_aroma(aromi)

    async def on_ws_connect(self):
        client = self._client
        if client:
            await client.publish("sauna_ctrl/availability", "online", qos=1, retain=True)
        self._ws_to_sbrio.put_nowait(dict(self._actuators))

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
            self._actuators["Kiuas_Button_LED"] = on
            self._ws_to_sbrio.put_nowait(dict(self._actuators))

    # ------------------------------------------------------------------ #
    # HA discovery                                                         #
    # ------------------------------------------------------------------ #

    async def _publish_discovery(self, client: aiomqtt.Client):
        sensors = [
            ("sauna_ceiling_temp", "Sauna Ceiling Temperature",
             "SaunaControl/ceiling_temp", "temperature", "°C"),
            ("sauna_kiuas_temp",   "Sauna Kiuas Temperature",
             "SaunaControl/kiuas_temp",   "temperature", "°C"),
            ("sauna_aromi_volume", "Sauna Aromi Volume",
             "SaunaControl/aromi_volume", None,          None),
        ]
        for obj_id, name, state_topic, dev_class, unit in sensors:
            cfg: dict = {
                "name": name,
                "state_topic": state_topic,
                "unique_id": obj_id,
                "device": _DEVICE,
                "availability": [_AVAIL],
                "expire_after": 60,
            }
            if dev_class:
                cfg["device_class"] = dev_class
            if unit:
                cfg["unit_of_measurement"] = unit
            await client.publish(
                f"homeassistant/sensor/{obj_id}/config",
                json.dumps(cfg), qos=1, retain=True,
            )

        await client.publish(
            "homeassistant/binary_sensor/sauna_door/config",
            json.dumps({
                "name": "Sauna Door",
                "state_topic": "SaunaControl/door",
                "unique_id": "sauna_door",
                "device": _DEVICE,
                "availability": [_AVAIL],
                "device_class": "door",
                "expire_after": 60,
                "payload_on": "ON",
                "payload_off": "OFF",
            }),
            qos=1, retain=True,
        )

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
