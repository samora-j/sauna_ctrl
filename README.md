# sauna_ctrl

Raspberry Pi bridge between a LabVIEW Real-Time sauna controller and Home Assistant. The RPi runs a WebSocket server that the LabVIEW RT node connects to as a client. All sauna I/O flows through this bridge: sensor data and events arrive from LabVIEW RT via WebSocket and are published to Home Assistant via MQTT. Commands from Home Assistant are forwarded back to LabVIEW RT via the same WebSocket connection.

---

## Repository Structure

```
sauna_ctrl/
├── main.py                  # Application entry point (asyncio event loop)
├── ws_server.py             # WebSocket server — receives sensor data, sends commands
├── mqtt_bridge.py           # MQTT publish/subscribe and HA discovery config
├── config.py                # GPIO and SPI hardware abstraction (RPi)
├── ST7789.py                # ST7789 TFT display driver (240×240)
├── requirements.txt         # Python dependencies
├── sauna-ctrl.service       # systemd service unit
├── sauna-ctrl.sh            # Launcher script
├── Inconsolata-Bold.ttf     # Display font
├── VolvoBroad.ttf           # Display font (secondary)
├── README.md
│
└── labview/                 # LabVIEW RT project
    ├── sauna_ctrl.lvproj
    ├── Main.vi              # Top-level RT VI (timed loop, all I/O)
    ├── ws/
    │   ├── WS Connect.vi          # Establish WebSocket client connection to RPi
    │   ├── WS Send Sensors.vi     # Serialize and send sensor batch message
    │   ├── WS Send Event.vi       # Send event message (power button press)
    │   ├── WS Receive.vi          # Non-blocking receive and dispatch
    │   └── WS Parse Command.vi    # Parse inbound command JSON from RPi
    ├── io/
    │   ├── Read Analog.vi         # Read temperature and aroma level channels
    │   ├── Read Digital.vi        # Read binary inputs (door, pump, spray, buttons)
    │   └── Write Digital.vi       # Write binary outputs (button lights)
    └── typedefs/
        ├── Sensor Data.ctl        # Cluster typedef for outbound sensor batch
        └── WS Command.ctl         # Cluster typedef for inbound commands
```

---

## System Architecture

```
LabVIEW RT Node                 Raspberry Pi                 Home Assistant
(WebSocket client)          (WebSocket server + MQTT bridge)  (MQTT broker: fusion:1883)
        │                              │                              │
        │  ←── WebSocket (port 8765) ──│                              │
        │                              │                              │
        │──── sensor batch ───────────►│──── sensor topics ──────────►│
        │──── power_button ───────────►│──── button action ──────────►│
        │                              │◄─── zigbee2mqtt/Sauna Power ─│
        │◄─── power_indicator ─────────│                              │
        │◄─── aroma_button_light ──────│  (sent once on WS connect)   │
        │◄─── spray_button_light ──────│                              │
        │◄─── zero_adjust ─────────────│◄─── zero adjust command ─────│
        │                              │                              │
        │              GPIO buttons on RPi ────────────────────────►│
```

The RPi retains its MQTT subscription to `zigbee2mqtt/Sauna Power` to track the actual relay state. This drives both the display and the `power_indicator` signal sent back to LabVIEW RT.

---

## WebSocket Protocol

**Server:** Raspberry Pi, port `8765`  
**Client:** LabVIEW RT node  
**Format:** UTF-8 JSON, one message per frame  
**Connection:** LabVIEW RT initiates and maintains the connection. The RPi server accepts one client at a time and handles reconnections gracefully.

### LabVIEW RT → RPi

#### Sensor Batch (periodic)

Sent every scan cycle (rate-limited on RPi side before MQTT publish). All fields are always present.

```json
{
  "type": "sensors",
  "ceiling_temp":      78.5,
  "heater_temp":       120.3,
  "aroma_level":       42.1,
  "water_spray":       false,
  "aroma_pump":        false,
  "door_closed":       true,
  "aroma_btn_pressed": false,
  "spray_btn_pressed": false
}
```

| Field | Type | Unit | Description |
|---|---|---|---|
| `ceiling_temp` | float | °C | Sauna ceiling air temperature |
| `heater_temp` | float | °C | Heater surface temperature |
| `aroma_level` | float | mL | Aroma oil volume remaining |
| `water_spray` | bool | — | Water spray actuator active |
| `aroma_pump` | bool | — | Aroma pump actuator active |
| `door_closed` | bool | — | `true` = door closed |
| `aroma_btn_pressed` | bool | — | Aroma button pressed (reserved for future RPi logic) |
| `spray_btn_pressed` | bool | — | Spray button pressed (reserved for future RPi logic) |

#### Power Button Event

Sent on the **rising edge** of the power button input (button press only, not release).

```json
{ "type": "power_button", "pressed": true }
```

---

### RPi → LabVIEW RT

All messages are sent as JSON frames on the same WebSocket connection.

#### Power Indicator

Sent whenever the RPi receives a power state update from Home Assistant. LabVIEW RT uses this to drive the LED in the physical power button inside the sauna.

```json
{ "type": "power_indicator", "state": true }
```

`true` = relay ON (sauna powered), `false` = relay OFF.

#### Aroma Button Light

Sent once when the WebSocket connection is established. Reserved for future RPi business logic.

```json
{ "type": "aroma_button_light", "state": false }
```

#### Spray Button Light

Sent once when the WebSocket connection is established. Reserved for future RPi business logic.

```json
{ "type": "spray_button_light", "state": false }
```

#### Zero Adjust

Sent when triggered from Home Assistant (button entity press). LabVIEW RT zeros the aroma level sensor on receipt.

```json
{ "type": "zero_adjust" }
```

---

## MQTT Topics

All topics use the broker at `fusion:1883`.

### RPi publishes (sensor data bridged from LabVIEW RT)

| Topic | Payload | HA entity type | Notes |
|---|---|---|---|
| `SaunaControl/ceiling_temp` | `"78.5"` | `sensor` | °C |
| `SaunaControl/heater_temp` | `"120.3"` | `sensor` | °C |
| `SaunaControl/aroma_level` | `"42.1"` | `sensor` | mL |
| `SaunaControl/water_spray` | `"ON"` / `"OFF"` | `binary_sensor` | |
| `SaunaControl/aroma_pump` | `"ON"` / `"OFF"` | `binary_sensor` | |
| `SaunaControl/door` | `"ON"` / `"OFF"` | `binary_sensor` | `ON` = open |

### RPi publishes (button events)

| Topic | Payload | Description |
|---|---|---|
| `sauna_ctrl/power_btn/action` | `"power_btn_pressed"` | Physical power button in sauna |
| `sauna_ctrl/sauna_ctrl_key_u/action` | `"key_u_pressed"` | RPi directional button |
| `sauna_ctrl/sauna_ctrl_key_d/action` | `"key_d_pressed"` | |
| `sauna_ctrl/sauna_ctrl_key_l/action` | `"key_l_pressed"` | |
| `sauna_ctrl/sauna_ctrl_key_r/action` | `"key_r_pressed"` | |
| `sauna_ctrl/sauna_ctrl_key_p/action` | `"key_p_pressed"` | |
| `sauna_ctrl/sauna_ctrl_key1/action` | `"key1_pressed"` | |
| `sauna_ctrl/sauna_ctrl_key2/action` | `"key2_pressed"` | |
| `sauna_ctrl/sauna_ctrl_key3/action` | `"key3_pressed"` | |

### RPi subscribes

| Topic | Source | Purpose |
|---|---|---|
| `zigbee2mqtt/Sauna Power` | Zigbee switch | Relay state → display + `power_indicator` to LabVIEW RT |
| `SaunaControl/zero_adjust/press` | Home Assistant | Trigger zero-adjust command to LabVIEW RT |

### Availability

| Topic | Payload | Notes |
|---|---|---|
| `sauna_ctrl/availability` | `"online"` / `"offline"` | Published on WS connect/disconnect. `"offline"` set as MQTT LWT with `retain=True`. |

---

## Home Assistant Discovery

All entities are published at startup to `homeassistant/<component>/<object_id>/config` with `retain=True`. All belong to the same HA device:

```json
{
  "identifiers": ["sauna_ctrl"],
  "name": "Sauna Controller",
  "model": "RPi + LabVIEW RT"
}
```

| Object ID | Component | Name | Device class | Unit |
|---|---|---|---|---|
| `sauna_ceiling_temp` | `sensor` | Sauna Ceiling Temperature | `temperature` | °C |
| `sauna_heater_temp` | `sensor` | Sauna Heater Temperature | `temperature` | °C |
| `sauna_aroma_level` | `sensor` | Sauna Aroma Level | — | mL |
| `sauna_water_spray` | `binary_sensor` | Sauna Water Spray | `running` | — |
| `sauna_aroma_pump` | `binary_sensor` | Sauna Aroma Pump | `running` | — |
| `sauna_door` | `binary_sensor` | Sauna Door | `door` | — |
| `sauna_zero_adjust` | `button` | Sauna Aroma Zero Adjust | — | — |
| `sauna_ctrl_key_*` | `device_automation` | (8 RPi buttons) | — | — |
| `sauna_power_btn` | `device_automation` | Sauna Power Button | — | — |

All sensor entities include `expire_after: 60` so HA marks them unavailable if the heartbeat stops.

---

## Update Rates

The RPi rate-limits MQTT publishing regardless of the WebSocket frame rate from LabVIEW RT.

| Data | Publish condition |
|---|---|
| `ceiling_temp`, `heater_temp` | Change ≥ 0.5 °C **or** every 30 s |
| `aroma_level` | Change ≥ 1 mL **or** every 30 s |
| `water_spray`, `aroma_pump`, `door` | Immediately on state change |
| Button events | Immediately on press |
| Availability | Immediately on WS connect / disconnect |

---

## RPi Software Stack

| Layer | Technology |
|---|---|
| Async runtime | `asyncio` |
| WebSocket server | `websockets` |
| MQTT client | `asyncio-mqtt` |
| Display | `Pillow` + ST7789 SPI driver |
| GPIO | `gpiozero` |

The main event loop runs three concurrent async tasks:
1. **WebSocket server** — receives sensor batches, dispatches to display + MQTT publish
2. **Button poll** — reads GPIO, publishes button events to MQTT
3. **MQTT client** — subscribes to power state and zero-adjust topics, forwards to display and WebSocket

---

## Display

Layout unchanged from original implementation (240×240 ST7789, Inconsolata-Bold 30 pt):

```
  Power: ON
   Temp: 78°C
  Aroma: 42 mL
```

`Temp` shows `ceiling_temp`. Menu-based UI using the RPi directional buttons is reserved for a future iteration.
