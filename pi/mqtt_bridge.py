import asyncio
import json
import logging
import time
from pathlib import Path

import aiomqtt

log = logging.getLogger(__name__)

_BROKER = "mqtt.samora.lan"
_PORT = 1883

_TEMP_DELTA = 0.5
_AROMA_DELTA = 1.0
_PERIODIC_S = 30.0

# Stream watchdog: if no sensor batch arrives from the sbRIO for this long, the
# device is marked unavailable. Must be safely longer than the sbRIO's batch
# cadence to avoid false offlines. The ws_client disables WS keepalive, so this
# is the only thing that catches a half-open connection where data silently stops.
_STREAM_STALL_S = 30.0
_WATCHDOG_TICK_S = 5.0

_STATE_FILE = Path(__file__).parent / "actuator_state.json"

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
    "Aromi_Pump_Cycle":     125,
}


class MQTTBridge:
    def __init__(self, state, display, ws_to_sbrio: asyncio.Queue):
        self._state = state
        self._display = display
        self._ws_to_sbrio = ws_to_sbrio
        self._client: aiomqtt.Client | None = None
        self._actuators = self._load_actuators()

        self._rl: dict = {
            "Ceiling_Temp": (None, 0.0),
            "Kiuas_Temp":   (None, 0.0),
            "Aromi_Volume": (None, 0.0),
        }
        self._bin: dict = {"door": None, "kiuas_button": None}

        self._last_batch: float | None = None
        self._stream_online: bool = False

    def _load_actuators(self) -> dict:
        state = dict(_ACTUATOR_DEFAULTS)
        try:
            saved = json.loads(_STATE_FILE.read_text())
            state.update({k: v for k, v in saved.items() if k in _ACTUATOR_DEFAULTS})
            log.info("Loaded actuator state from %s", _STATE_FILE)
        except (FileNotFoundError, json.JSONDecodeError, OSError):
            log.info("No saved actuator state — using defaults")
        state["Aromi_Pump_Cycle"] = 125
        return state

    def _save_actuators(self):
        try:
            _STATE_FILE.write_text(json.dumps(self._actuators))
        except OSError as exc:
            log.warning("Failed to save actuator state: %s", exc)

    # ------------------------------------------------------------------ #
    # Callbacks invoked by ws_client                                       #
    # ------------------------------------------------------------------ #

    async def on_sensors(self, msg: dict):
        client = self._client
        if client is None:
            return

        now = time.monotonic()
        self._last_batch = now
        if not self._stream_online:
            await self._set_stream_online(True)

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
            if not kiuas_btn and self._bin["kiuas_button"]:  # falling edge = release
                log.debug("Kiuas button released — publishing power_btn_pressed")
                await client.publish("sauna_ctrl/power_btn/action", "power_btn_pressed", qos=1)
            self._bin["kiuas_button"] = kiuas_btn

        door = msg.get("Door")
        if door is not None and door != self._bin["door"]:
            # Door=true → open → HA ON; Door=false → closed → HA OFF.
            # Retained so HA gets the current state on (re)subscribe — the door
            # publishes on change only, so without retain a restart shows unknown.
            await client.publish(
                "SaunaControl/door", "ON" if door else "OFF", qos=1, retain=True
            )
            self._bin["door"] = door

        ceiling = msg.get("Ceiling_Temp")
        aromi = msg.get("Aromi_Volume")
        if ceiling is not None:
            self._display.update_temp(ceiling)
        if aromi is not None:
            self._display.update_aroma(aromi)

    def _set_enable(self, channel: str, on: bool):
        if channel == "loyly":
            self._actuators["Loyly_Valve_Enable"] = on
            self._actuators["Loyly_Button_LED"] = on
        elif channel == "aromi":
            self._actuators["Aromi_Pump_Enable"] = on
            self._actuators["Aromi_Button_LED"] = on
        self._ws_to_sbrio.put_nowait(dict(self._actuators))
        self._save_actuators()

    async def _set_stream_online(self, online: bool):
        """Publish availability, but only on a transition to avoid spamming."""
        if online == self._stream_online:
            return
        self._stream_online = online
        client = self._client
        if client:
            await client.publish(
                "sauna_ctrl/availability",
                "online" if online else "offline",
                qos=1, retain=True,
            )
        log.info("sbRIO stream %s", "online" if online else "offline")

    async def on_ws_connect(self):
        # Availability is driven by the data stream (first batch / watchdog),
        # not the WS connect itself — the socket can be up with no data flowing.
        self._ws_to_sbrio.put_nowait(dict(self._actuators))

    async def on_ws_disconnect(self):
        self._last_batch = None
        await self._set_stream_online(False)

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
            # Force the next availability decision to publish (the retained LWT
            # may have flipped us offline while MQTT was down).
            self._stream_online = False
            log.info("MQTT connected to %s:%d", _BROKER, _PORT)

            await self._publish_discovery(client)
            await client.subscribe("zigbee2mqtt/Sauna Power")
            await client.subscribe("SaunaControl/loyly_enable/set")
            await client.subscribe("SaunaControl/aromi_enable/set")

            # Publish current enable states so HA is in sync after reconnect
            await client.publish("SaunaControl/loyly_enable",
                "ON" if self._actuators["Loyly_Valve_Enable"] else "OFF", qos=1, retain=True)
            await client.publish("SaunaControl/aromi_enable",
                "ON" if self._actuators["Aromi_Pump_Enable"] else "OFF", qos=1, retain=True)

            # Republish online immediately if the stream is already alive,
            # otherwise leave it to the next batch / watchdog.
            if (self._state.ws_connected and self._last_batch is not None
                    and (time.monotonic() - self._last_batch) <= _STREAM_STALL_S):
                await self._set_stream_online(True)

            watchdog = asyncio.create_task(self._stream_watchdog())
            try:
                async for message in client.messages:
                    await self._handle(client, message)
            finally:
                watchdog.cancel()

    async def _stream_watchdog(self):
        """Mark the device offline if the sbRIO stops feeding sensor batches."""
        while True:
            await asyncio.sleep(_WATCHDOG_TICK_S)
            if self._last_batch is None or not self._stream_online:
                continue
            if (time.monotonic() - self._last_batch) > _STREAM_STALL_S:
                log.warning("No sbRIO sensor batch for >%.0fs — marking offline",
                            _STREAM_STALL_S)
                await self._set_stream_online(False)

    async def _handle(self, client: aiomqtt.Client, message):
        topic = str(message.topic)
        payload = message.payload.decode()

        if topic == "SaunaControl/loyly_enable/set":
            on = payload.strip().upper() == "ON"
            self._set_enable("loyly", on)
            await client.publish("SaunaControl/loyly_enable", "ON" if on else "OFF", qos=1, retain=True)

        elif topic == "SaunaControl/aromi_enable/set":
            on = payload.strip().upper() == "ON"
            self._set_enable("aromi", on)
            await client.publish("SaunaControl/aromi_enable", "ON" if on else "OFF", qos=1, retain=True)

        elif topic == "zigbee2mqtt/Sauna Power":
            try:
                on = json.loads(payload).get("state", "").upper() == "ON"
            except (json.JSONDecodeError, AttributeError):
                on = payload.strip().upper() == "ON"
            self._state.power_on = on
            self._display.update_power(on)
            self._actuators["Kiuas_Button_LED"] = on
            self._ws_to_sbrio.put_nowait(dict(self._actuators))
            self._save_actuators()

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
                "payload_on": "ON",
                "payload_off": "OFF",
            }),
            qos=1, retain=True,
        )

        for obj_id, name, state_topic, cmd_topic in (
            ("sauna_loyly_enable", "Enable Löyly",
             "SaunaControl/loyly_enable", "SaunaControl/loyly_enable/set"),
            ("sauna_aromi_enable", "Enable Aromi",
             "SaunaControl/aromi_enable", "SaunaControl/aromi_enable/set"),
        ):
            await client.publish(
                f"homeassistant/switch/{obj_id}/config",
                json.dumps({
                    "name": name,
                    "state_topic": state_topic,
                    "command_topic": cmd_topic,
                    "payload_on": "ON",
                    "payload_off": "OFF",
                    "unique_id": obj_id,
                    "device": _DEVICE,
                    "availability": [_AVAIL],
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
