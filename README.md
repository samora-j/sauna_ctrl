# sauna_ctrl

Raspberry Pi bridge between a LabVIEW Real-Time sbRIO-9642 sauna controller and Home Assistant. The sbRIO runs a WebSocket server; the RPi connects as a client, bridges sensor data to Home Assistant via MQTT, and sends actuator and setting commands back to the sbRIO.

---

## Repository Structure

```
sauna_ctrl/
├── pi/                        # RPi Python bridge
│   ├── main.py                # asyncio entry point, display, GPIO buttons
│   ├── ws_client.py           # WebSocket client task (connects to sbRIO)
│   ├── mqtt_bridge.py         # MQTT publish/subscribe and HA discovery
│   ├── lms_client.py          # Lyrion Music Server JSON-RPC media control
│   ├── config.py              # GPIO and SPI hardware abstraction
│   ├── ST7789.py              # ST7789 TFT display driver (240×240)
│   ├── requirements.txt       # Python dependencies
│   ├── actuator_state.json    # Persisted actuator state (auto-created at runtime)
│   ├── Inconsolata-Bold.ttf
│   └── VolvoBroad.ttf
├── labview/sbRIO-9642/        # LabVIEW RT + FPGA project
│   ├── Main.vi                # Top-level (deploys RT + FPGA)
│   ├── RT-Main.vi             # RT main loop
│   ├── Sauna_9642_FPGA_Main.vi       # FPGA main (scan engine)
│   ├── RT_Read_Websocket.vi          # Receive actuator/setting commands from RPi
│   ├── ReadSensors.vi                # Read and pack sensor/button state
│   ├── WriteSettingsAndActuators.vi  # Apply received commands to I/O
│   ├── ObtainNotifiers.vi            # Notifier wiring between RT loops
│   ├── Sensors_State.ctl             # Typedef: outbound sensor batch
│   └── Settings_Actuators.ctl        # Typedef: inbound actuator/setting commands
├── tools/
│   ├── sbrio_ws_test.html     # Browser-based WS test client for the sbRIO
│   └── fix_planhead_vcredist.reg  # Registry fix for FPGA compile worker
├── config/systemd/            # sauna-ctrl.service, deploy timer
├── deploy.sh                  # Auto-deploy: git pull, pip sync, restart
├── setup-pi.sh                # One-time RPi setup
└── README.md
```

---

## System Architecture

```
LabVIEW RT sbRIO-9642          Raspberry Pi                 Home Assistant
(WebSocket server :6123)    (WebSocket client + MQTT bridge)  (mqtt.samora.lan:1883)
        │                              │                              │
        │──── sensor/button state ────►│──── sensor topics ──────────►│
        │                              │◄─── power state ─────────────│
        │◄─── actuator/settings ───────│──── button events ──────────►│
        │                              │◄─── enable commands ──────────│
        │              GPIO buttons on RPi ───────────────────────────►│
```

The sbRIO-9642 broadcasts sensor and button state. The RPi bridges this to Home Assistant via MQTT and sends actuator and setting commands back to the sbRIO. Actuator state is persisted to `pi/actuator_state.json` so it survives service restarts.

---

## WebSocket Protocol

**Server:** sbRIO-9642, port `6123`  
**Client:** Raspberry Pi  
**Format:** UTF-8 JSON, one message per frame  
**Keepalive:** disabled (`ping_interval=None`) — sbRIO does not respond to WebSocket pings; the sensor data stream serves as implicit keepalive, watched by the availability watchdog (see [Availability](#availability))

### sbRIO → RPi (sensor and button state)

Sent periodically. All fields are always present.

```json
{
  "Kiuas_Button":  false,
  "Loyly_Button":  false,
  "Aromi_Button":  false,
  "Door":          false,
  "Ceiling_Temp":  78.50,
  "Kiuas_Temp":    120.30,
  "Aromi_Volume":  42.00
}
```

| Field | Type | Unit | Description |
|---|---|---|---|
| `Kiuas_Button` | bool | — | Kiuas (heater) button state |
| `Loyly_Button` | bool | — | Löyly (steam) button state |
| `Aromi_Button` | bool | — | Aromi (scent) button state |
| `Door` | bool | — | `true` = door **open** |
| `Ceiling_Temp` | float | °C | Sauna ceiling air temperature |
| `Kiuas_Temp` | float | °C | Kiuas heater surface temperature |
| `Aromi_Volume` | float | — | Aroma oil volume remaining |

**Button edge detection:** The RPi detects falling edges (release) on `Kiuas_Button` to trigger the sauna power toggle. `Loyly_Button` and `Aromi_Button` are received but not yet acted on.

### RPi → sbRIO (actuator and setting commands)

Sent on WS connect and whenever any value changes. All fields included in each message.

```json
{
  "Kiuas_Button_LED":     false,
  "Loyly_Button_LED":     false,
  "Loyly_Valve_Enable":   false,
  "Loyly_Valve":          false,
  "Aromi_Button_LED":     false,
  "Aromi_Pump_Enable":    false,
  "Aromi_Pump":           false,
  "Aromi_Pump_Direction": false,
  "Aromi_Pump_Cycle":     125
}
```

| Field | Type | Description |
|---|---|---|
| `Kiuas_Button_LED` | bool | Kiuas button backlight — follows sauna power state |
| `Loyly_Button_LED` | bool | Löyly button backlight — follows `Loyly_Valve_Enable` |
| `Loyly_Valve_Enable` | bool | Enable Löyly valve control |
| `Loyly_Valve` | bool | Löyly water valve open/closed |
| `Aromi_Button_LED` | bool | Aromi button backlight — follows `Aromi_Pump_Enable` |
| `Aromi_Pump_Enable` | bool | Enable Aromi pump control |
| `Aromi_Pump` | bool | Aromi pump on/off |
| `Aromi_Pump_Direction` | bool | Aromi pump direction |
| `Aromi_Pump_Cycle` | uint16 | Aromi pump duty cycle — hardcoded to 125 |

---

## MQTT Topics

All topics use the broker at `mqtt.samora.lan:1883`.

### RPi publishes (sensor data bridged from sbRIO)

| Topic | Payload | HA entity type | Notes |
|---|---|---|---|
| `SaunaControl/ceiling_temp` | `"78.5"` | `sensor` | °C |
| `SaunaControl/kiuas_temp` | `"120.3"` | `sensor` | °C |
| `SaunaControl/aromi_volume` | `"42.0"` | `sensor` | — |
| `SaunaControl/door` | `"ON"` / `"OFF"` | `binary_sensor` | `ON` = open |

### RPi publishes (enable state, retained)

| Topic | Payload | Notes |
|---|---|---|
| `SaunaControl/loyly_enable` | `"ON"` / `"OFF"` | Published on MQTT connect and on change |
| `SaunaControl/aromi_enable` | `"ON"` / `"OFF"` | Published on MQTT connect and on change |

### RPi publishes (button events)

Only the power and spare buttons are bridged to Home Assistant over MQTT.
Media-transport buttons are handled on the Pi directly against LMS (see below)
and are **not** published.

| Topic | Payload | Description |
|---|---|---|
| `sauna_ctrl/power_btn/action` | `"power_btn_pressed"` | Kiuas button release on sbRIO → HA power toggle |
| `sauna_ctrl/sauna_ctrl_key3/action` | `"key3_pressed"` | RPi button outside the door → HA power toggle |
| `sauna_ctrl/sauna_ctrl_key_p/action` | `"key_p_pressed"` | RPi joystick press — spare/unused |

### RPi media control (LMS JSON-RPC, no HA round-trip)

The RPi drives the **Sauna** Squeezebox player directly via the LMS JSON-RPC
endpoint (`lyrion.samora.lan:9000/jsonrpc.js`), so media works even when Home
Assistant is down. HA's `media_player.sauna` still mirrors state because the
squeezebox integration polls LMS. See `pi/lms_client.py`.

| Button | Action |
|---|---|
| `key1` | Play/pause toggle |
| `key2` | Player on/off toggle |
| `key_d` | Volume up |
| `key_u` | Volume down |
| `key_l` | Next track |
| `key_r` | Previous track |

### RPi subscribes

| Topic | Source | Purpose |
|---|---|---|
| `zigbee2mqtt/Sauna Power` | Zigbee relay | Power state → display + `Kiuas_Button_LED` to sbRIO |
| `SaunaControl/loyly_enable/set` | Home Assistant | Toggle Löyly enable + LED |
| `SaunaControl/aromi_enable/set` | Home Assistant | Toggle Aromi enable + LED |

### Availability

The single liveness signal for the whole device. All entities reference it via
`availability`, so they show `unavailable` together whenever the data stream is
down. It is driven by the **inbound sensor-batch stream**, not just the WS
socket state — because WS keepalive is disabled, a half-open connection where
the socket stays up but frames stop would otherwise go unnoticed.

| Condition | Payload |
|---|---|
| First sensor batch received | `"online"` |
| No sensor batch for > 30 s (`_STREAM_STALL_S`, watchdog) | `"offline"` |
| WS disconnect | `"offline"` |
| RPi process dies / MQTT drops | `"offline"` (MQTT LWT, `retain=True`) |

A 5 s watchdog (`_WATCHDOG_TICK_S`) checks the time since the last batch. The
stall threshold must stay safely above the sbRIO's batch cadence to avoid false
offlines. This replaces the old per-sensor `expire_after` on the door, which
falsely flapped to unavailable whenever the door simply hadn't changed for 60 s
(it publishes on change only).

---

## Home Assistant Discovery

All entities published to `homeassistant/<component>/<object_id>/config` with `retain=True`.

```json
{
  "identifiers": ["sauna_ctrl"],
  "name": "Sauna Controller",
  "model": "RPi + sbRIO-9642"
}
```

| Object ID | Component | Name | Notes |
|---|---|---|---|
| `sauna_ceiling_temp` | `sensor` | Sauna Ceiling Temperature | °C, `expire_after: 60` |
| `sauna_kiuas_temp` | `sensor` | Sauna Kiuas Temperature | °C, `expire_after: 60` |
| `sauna_aromi_volume` | `sensor` | Sauna Aromi Volume | `expire_after: 60` |
| `sauna_door` | `binary_sensor` | Sauna Door | `device_class: door`, retained, no `expire_after` (liveness via availability) |
| `sauna_loyly_enable` | `switch` | Enable Löyly | Command: `SaunaControl/loyly_enable/set` |
| `sauna_aromi_enable` | `switch` | Enable Aromi | Command: `SaunaControl/aromi_enable/set` |
| `sauna_power_btn` | `device_automation` | Sauna Power Button | Trigger on `sauna_ctrl/power_btn/action` |
| `sauna_ctrl_key_*` | `device_automation` | (8 RPi GPIO buttons) | — |

---

## Update Rates

| Data | Publish condition |
|---|---|
| `ceiling_temp`, `kiuas_temp` | Change ≥ 0.5 °C **or** every 30 s |
| `aromi_volume` | Change ≥ 1 unit **or** every 30 s |
| `door` | Immediately on state change (retained) |
| Button events | Immediately on press/release |
| Enable state | On MQTT connect (retained) and on change |
| Availability | `online` on first batch; `offline` on stream stall (>30 s), WS disconnect, or LWT |

---

## RPi Software Stack

| Layer | Technology |
|---|---|
| Async runtime | `asyncio` (Python 3.9 — uses `asyncio.gather`, not `TaskGroup`) |
| WebSocket client | `websockets` |
| MQTT client | `aiomqtt` |
| Display | `Pillow` + ST7789 SPI driver |
| GPIO | `gpiozero` + `RPi.GPIO` (pin factory for PWM support) |

Three concurrent async tasks via `asyncio.gather`:
1. **WebSocket client** — connects to sbRIO, receives sensor batches, sends actuator commands; reconnects on failure
2. **Button poll** — 20 Hz GPIO poll; on rising edge, power/spare buttons publish to MQTT and media buttons call LMS directly (`lms_client.py`)
3. **MQTT client** — subscribes to power state and enable command topics; updates display, actuators, and sbRIO

---

## Display

240×240 ST7789 TFT, Inconsolata-Bold 30 pt:

```
  Power: ON
   Temp: 78°C
  Aromi: 42
```

---

## Auto-deploy

Systemd timer fires `deploy.sh` every 30 s. Fetches from GitHub; if `pi/` changed, syncs deps and restarts `sauna-ctrl`. Venv at `pi/venv/`, service runs as `marcushj`.

---

## Known Issues / Open Debugging

**Sauna power toggle (resolved 2026-06-13):** The cause was a topic mismatch — the rebuilt controller publishes the Kiuas press to `sauna_ctrl/power_btn/action`, but the HA automation still listened to the old `sauna_ctrl/sauna_ctrl_key3/action`. HA's "sauna_ctrl Toggle Power" automation now triggers on **both** `power_btn` (Kiuas, inside) and `key3` (RPi button, outside the door).
