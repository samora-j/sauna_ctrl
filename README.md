# sauna_ctrl

Raspberry Pi bridge between a LabVIEW Real-Time sbRIO-9642 sauna controller and Home Assistant. The sbRIO runs a WebSocket server; the RPi connects as a client, bridges sensor data to Home Assistant via MQTT, and sends actuator and setting commands back to the sbRIO.

---

## Repository Structure

```
sauna_ctrl/
├── pi/                        # RPi Python bridge
│   ├── main.py                # asyncio entry point, display, GPIO buttons
│   ├── ws_server.py           # WebSocket task (pending migration to WS client)
│   ├── mqtt_bridge.py         # MQTT publish/subscribe and HA discovery
│   ├── config.py              # GPIO and SPI hardware abstraction
│   ├── ST7789.py              # ST7789 TFT display driver (240×240)
│   ├── requirements.txt       # Python dependencies
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
        │                              │                              │
        │              GPIO buttons on RPi ───────────────────────────►│
```

The sbRIO-9642 broadcasts sensor and button state. The RPi bridges this to Home Assistant via MQTT and sends actuator and setting commands back to the sbRIO.

---

## WebSocket Protocol

**Server:** sbRIO-9642, port `6123`  
**Client:** Raspberry Pi  
**Format:** UTF-8 JSON, one message per frame

### sbRIO → RPi (sensor and button state)

Sent periodically. All fields are always present.

```json
{
  "Kiuas_Button":  false,
  "Loyly_Button":  false,
  "Aromi_Button":  false,
  "Door":          true,
  "Ceiling_Temp":  78.50,
  "Kiuas_Temp":    120.30,
  "Aromi_Volume":  42.00
}
```

| Field | Type | Unit | Description |
|---|---|---|---|
| `Kiuas_Button` | bool | — | Kiuas (heater) button pressed |
| `Loyly_Button` | bool | — | Löyly (steam) button pressed |
| `Aromi_Button` | bool | — | Aromi (scent) button pressed |
| `Door` | bool | — | `true` = door closed |
| `Ceiling_Temp` | float | °C | Sauna ceiling air temperature |
| `Kiuas_Temp` | float | °C | Kiuas heater surface temperature |
| `Aromi_Volume` | float | — | Aroma oil volume remaining |

### RPi → sbRIO (actuator and setting commands)

Sent when any value changes and on reconnect to sync state. All fields included in each message.

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
  "Aromi_Pump_Cycle":     0
}
```

| Field | Type | Description |
|---|---|---|
| `Kiuas_Button_LED` | bool | Kiuas button backlight |
| `Loyly_Button_LED` | bool | Löyly button backlight |
| `Loyly_Valve_Enable` | bool | Enable Löyly valve control |
| `Loyly_Valve` | bool | Löyly water valve open/closed |
| `Aromi_Button_LED` | bool | Aromi button backlight |
| `Aromi_Pump_Enable` | bool | Enable Aromi pump control |
| `Aromi_Pump` | bool | Aromi pump on/off |
| `Aromi_Pump_Direction` | bool | Aromi pump direction |
| `Aromi_Pump_Cycle` | uint16 | Aromi pump duty cycle (0–65535) |

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

### RPi publishes (button events)

| Topic | Payload | Description |
|---|---|---|
| `sauna_ctrl/sauna_ctrl_key_u/action` | `"key_u_pressed"` | RPi directional button up |
| `sauna_ctrl/sauna_ctrl_key_d/action` | `"key_d_pressed"` | down |
| `sauna_ctrl/sauna_ctrl_key_l/action` | `"key_l_pressed"` | left |
| `sauna_ctrl/sauna_ctrl_key_r/action` | `"key_r_pressed"` | right |
| `sauna_ctrl/sauna_ctrl_key_p/action` | `"key_p_pressed"` | press |
| `sauna_ctrl/sauna_ctrl_key1/action` | `"key1_pressed"` | |
| `sauna_ctrl/sauna_ctrl_key2/action` | `"key2_pressed"` | |
| `sauna_ctrl/sauna_ctrl_key3/action` | `"key3_pressed"` | |

### RPi subscribes

| Topic | Source | Purpose |
|---|---|---|
| `zigbee2mqtt/Sauna Power` | Zigbee relay | Power state → display + `Kiuas_Button_LED` to sbRIO |

### Availability

| Topic | Payload | Notes |
|---|---|---|
| `sauna_ctrl/availability` | `"online"` / `"offline"` | Published on WS connect/disconnect. `"offline"` set as MQTT LWT with `retain=True`. |

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

| Object ID | Component | Name | Device class | Unit |
|---|---|---|---|---|
| `sauna_ceiling_temp` | `sensor` | Sauna Ceiling Temperature | `temperature` | °C |
| `sauna_kiuas_temp` | `sensor` | Sauna Kiuas Temperature | `temperature` | °C |
| `sauna_aromi_volume` | `sensor` | Sauna Aromi Volume | — | — |
| `sauna_door` | `binary_sensor` | Sauna Door | `door` | — |
| `sauna_ctrl_key_*` | `device_automation` | (8 RPi buttons) | — | — |

All sensor entities include `expire_after: 60`.

---

## Update Rates

| Data | Publish condition |
|---|---|
| `ceiling_temp`, `kiuas_temp` | Change ≥ 0.5 °C **or** every 30 s |
| `aromi_volume` | Change ≥ 1 unit **or** every 30 s |
| `door` | Immediately on state change |
| Button events | Immediately on press |
| Availability | Immediately on WS connect / disconnect |

---

## RPi Software Stack

| Layer | Technology |
|---|---|
| Async runtime | `asyncio` |
| WebSocket client | `websockets` |
| MQTT client | `aiomqtt` |
| Display | `Pillow` + ST7789 SPI driver |
| GPIO | `gpiozero` |

Three concurrent async tasks:
1. **WebSocket client** — connects to sbRIO, receives sensor batches, sends actuator commands
2. **Button poll** — reads GPIO, publishes button events to MQTT
3. **MQTT client** — subscribes to power state topic, updates display and button LEDs

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

Systemd timer fires `deploy.sh` every 30 s. Detects changes in `pi/` → restarts `sauna-ctrl`. Venv at `pi/venv/`, service runs as `marcushj`.
