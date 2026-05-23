import asyncio
import logging
from dataclasses import dataclass
from pathlib import Path

import ST7789
from PIL import Image, ImageDraw, ImageFont

from ws_server import ws_server_task
from mqtt_bridge import MQTTBridge

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(name)s: %(message)s",
)
log = logging.getLogger(__name__)

_FONT_PATH = Path(__file__).parent / "Inconsolata-Bold.ttf"

_BUTTON_PINS = {
    "key_u": "GPIO_KEY_UP_PIN",
    "key_d": "GPIO_KEY_DOWN_PIN",
    "key_l": "GPIO_KEY_LEFT_PIN",
    "key_r": "GPIO_KEY_RIGHT_PIN",
    "key_p": "GPIO_KEY_PRESS_PIN",
    "key1":  "GPIO_KEY1_PIN",
    "key2":  "GPIO_KEY2_PIN",
    "key3":  "GPIO_KEY3_PIN",
}


@dataclass
class AppState:
    power_on: bool = False
    ws_connected: bool = False


class Display:
    def __init__(self, hw: ST7789.ST7789):
        self._hw = hw
        self._font = ImageFont.truetype(_FONT_PATH, 30)
        self._img = Image.new("RGB", (hw.width, hw.height), "BLACK")
        self._draw = ImageDraw.Draw(self._img)
        self._draw.text((5, 10),  "  Power:", fill="WHITE", font=self._font)
        self._draw.text((5, 80),  "   Temp:", fill="WHITE", font=self._font)
        self._draw.text((5, 150), "  Aroma:", fill="WHITE", font=self._font)
        self._flush()

    def update_power(self, on: bool):
        label = "ON" if on else "OFF"
        self._draw.rectangle((130, 0, 240, 40), fill="BLACK")
        self._draw.text((130, 10), label.rjust(5), fill="WHITE", font=self._font)
        self._flush()

    def update_temp(self, val: float):
        self._draw.rectangle((130, 80, 240, 120), fill="BLACK")
        self._draw.text((130, 80), f"{val:.1f}".rjust(5), fill="WHITE", font=self._font)
        self._flush()

    def update_aroma(self, val: float):
        self._draw.rectangle((130, 150, 240, 190), fill="BLACK")
        self._draw.text((130, 150), f"{val:.1f}".rjust(5), fill="WHITE", font=self._font)
        self._flush()

    def _flush(self):
        self._hw.ShowImage(self._img.rotate(180))


async def _button_poll_task(hw: ST7789.ST7789, bridge: MQTTBridge):
    prev = {key: 0 for key in _BUTTON_PINS}
    while True:
        for key, pin_attr in _BUTTON_PINS.items():
            val = hw.digital_read(getattr(hw, pin_attr))
            if val != prev[key]:
                prev[key] = val
                if val == 1:
                    await bridge.publish_button(key)
        await asyncio.sleep(0.05)


async def main():
    hw = ST7789.ST7789()
    hw.Init()
    hw.clear()
    hw.bl_DutyCycle(50)

    state = AppState()
    display = Display(hw)
    ws_to_lv: asyncio.Queue = asyncio.Queue()
    bridge = MQTTBridge(state, display, ws_to_lv)

    try:
        async with asyncio.TaskGroup() as tg:
            tg.create_task(
                ws_server_task(
                    ws_to_lv, state,
                    on_sensors=bridge.on_sensors,
                    on_power_btn=bridge.on_power_btn,
                    on_connect=bridge.on_ws_connect,
                    on_disconnect=bridge.on_ws_disconnect,
                ),
                name="ws-server",
            )
            tg.create_task(bridge.run(), name="mqtt")
            tg.create_task(_button_poll_task(hw, bridge), name="buttons")
    finally:
        hw.module_exit()


if __name__ == "__main__":
    asyncio.run(main())
