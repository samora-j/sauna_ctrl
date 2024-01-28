import spidev as SPI
import logging
import ST7789
import time
import json
import paho.mqtt.client as mqtt

from PIL import Image, ImageDraw, ImageFont
from struct import *


# topics
tp_pwr = "zigbee2mqtt/0xe0798dfffe57ec82/set"
tp_t_0 = "SaunaTemp/Temp0"
tp_t_1 = "SaunaTemp/Temp1"
MQTT_TOPICS = [(tp_pwr, 1), (tp_t_0, 1), (tp_t_1, 1)]

key3_disc_topic = "homeassistant/device_automation/sauna_ctrl_key3/action_key3_press/config"
key3_disc_payload = {
    "automation_type": "trigger",
    "type": "action",
    "subtype": "key3_pressed",
    "payload": "key3_pressed",
    "topic": "sauna_ctrl/sauna_ctrl_key3/action",
    "device": {
        "identifiers": [
            "sauna_ctrl_key3"
        ]
    }
}
key3_trig_topic = "sauna_ctrl/sauna_ctrl_key3/action"
key3_trig_payload = "key3_pressed"

logging.basicConfig(level=logging.DEBUG)
# 240x240 display with hardware SPI:
disp = ST7789.ST7789()

# Initialize library.
disp.Init()
disp.clear()
disp.bl_DutyCycle(50)
Font = ImageFont.truetype("Inconsolata-Bold.ttf", 35)

# Create blank image for drawing.
image1 = Image.new("RGB", (disp.width, disp.height), "BLACK")
draw = ImageDraw.Draw(image1)


draw.text((5, 10),   '  Power:', fill="WHITE", font=Font)
draw.text((5, 80),  ' Heater:', fill="WHITE", font=Font)
draw.text((5, 150), 'Ceiling:', fill="WHITE", font=Font)
im_r = image1.rotate(180)
disp.ShowImage(im_r)

def on_connect(client, userdata, flags, rc):
    print("Connected with result code "+str(rc))
    client.subscribe(MQTT_TOPICS)


def on_message(client, userdata, msg):
    print(msg.topic+" "+str(msg.payload))
    if msg.topic == tp_pwr:
        print("update power state")
        draw.rectangle((160, 0, 240, 40), fill="BLACK")
        draw.text((160, 10), msg.payload.decode(), fill="WHITE", font=Font)
        im_r = image1.rotate(180)
        disp.ShowImage(im_r)

    if msg.topic == tp_t_0:
        print("update heater temp")
        draw.rectangle((160, 80, 240, 120), fill="BLACK")
        data = json.loads(msg.payload.decode())
        h_temp = float(data['temperature'])
        h_temp_str = "{:.1f}".format(h_temp)
        draw.text((160, 80), h_temp_str.rjust(5), fill="WHITE", font=Font)
        im_r = image1.rotate(180)
        disp.ShowImage(im_r)

client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message

client.connect("fusion", 1883, 60)
client.loop_start()

client.publish(topic=key3_disc_topic, payload=str(key3_disc_payload), qos=2, retain=False)



key1 = 0
p_key1 = 0
key2 = 0
p_key2 = 0
key3 = 0
p_key3 = 0

try:
    while True:
        key3 = disp.digital_read(disp.GPIO_KEY3_PIN)
        key2 = disp.digital_read(disp.GPIO_KEY2_PIN)
        key1 = disp.digital_read(disp.GPIO_KEY1_PIN)
        if key3 != p_key3:
            p_key3 = key3
            if key3 == 1:
                print("key3 pressed - toggle power")
                client.publish(topic=key3_trig_topic, payload=str(key3_trig_payload), qos=1, retain=False)


except:
    print("exception")
client.loop_stop(force=False)
disp.module_exit()



