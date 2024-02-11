import spidev as SPI
import logging
import ST7789
import time
import json
import paho.mqtt.client as mqtt

from PIL import Image, ImageDraw, ImageFont
from struct import *


# topics
tp_pwr_state = "zigbee2mqtt/0xe0798dfffe57ec82"
tp_t_0 = "SaunaTemp/Temp0"
tp_t_1 = "SaunaTemp/Temp1"
MQTT_TOPICS = [(tp_pwr_state, 1), (tp_t_0, 1), (tp_t_1, 1)]


key_u_disc_topic = "homeassistant/device_automation/sauna_ctrl_key_u/action_key_u_press/config"
key_u_disc_payload = {
    "automation_type": "trigger",
    "type": "action",
    "subtype": "key_u_pressed",
    "payload": "key_u_pressed",
    "topic": "sauna_ctrl/sauna_ctrl_key_u/action",
    "device": {
        "identifiers": [
            "sauna_ctrl_key_u"
        ]
    }
}
key_u_trig_topic = "sauna_ctrl/sauna_ctrl_key_u/action"
key_u_trig_payload = "key_u_pressed"

key_d_disc_topic = "homeassistant/device_automation/sauna_ctrl_key_d/action_key_d_press/config"
key_d_disc_payload = {
    "automation_type": "trigger",
    "type": "action",
    "subtype": "key_d_pressed",
    "payload": "key_d_pressed",
    "topic": "sauna_ctrl/sauna_ctrl_key_d/action",
    "device": {
        "identifiers": [
            "sauna_ctrl_key_d"
        ]
    }
}
key_d_trig_topic = "sauna_ctrl/sauna_ctrl_key_d/action"
key_d_trig_payload = "key_d_pressed"

key_l_disc_topic = "homeassistant/device_automation/sauna_ctrl_key_l/action_key_l_press/config"
key_l_disc_payload = {
    "automation_type": "trigger",
    "type": "action",
    "subtype": "key_l_pressed",
    "payload": "key_l_pressed",
    "topic": "sauna_ctrl/sauna_ctrl_key_l/action",
    "device": {
        "identifiers": [
            "sauna_ctrl_key_l"
        ]
    }
}
key_l_trig_topic = "sauna_ctrl/sauna_ctrl_key_l/action"
key_l_trig_payload = "key_l_pressed"

key_r_disc_topic = "homeassistant/device_automation/sauna_ctrl_key_r/action_key_r_press/config"
key_r_disc_payload = {
    "automation_type": "trigger",
    "type": "action",
    "subtype": "key_r_pressed",
    "payload": "key_r_pressed",
    "topic": "sauna_ctrl/sauna_ctrl_key_r/action",
    "device": {
        "identifiers": [
            "sauna_ctrl_key_r"
        ]
    }
}
key_r_trig_topic = "sauna_ctrl/sauna_ctrl_key_r/action"
key_r_trig_payload = "key_r_pressed"

key_p_disc_topic = "homeassistant/device_automation/sauna_ctrl_key_p/action_key_p_press/config"
key_p_disc_payload = {
    "automation_type": "trigger",
    "type": "action",
    "subtype": "key_p_pressed",
    "payload": "key_p_pressed",
    "topic": "sauna_ctrl/sauna_ctrl_key_p/action",
    "device": {
        "identifiers": [
            "sauna_ctrl_key_p"
        ]
    }
}
key_p_trig_topic = "sauna_ctrl/sauna_ctrl_key_p/action"
key_p_trig_payload = "key_p_pressed"

key1_disc_topic = "homeassistant/device_automation/sauna_ctrl_key1/action_key1_press/config"
key1_disc_payload = {
    "automation_type": "trigger",
    "type": "action",
    "subtype": "key1_pressed",
    "payload": "key1_pressed",
    "topic": "sauna_ctrl/sauna_ctrl_key1/action",
    "device": {
        "identifiers": [
            "sauna_ctrl_key1"
        ]
    }
}
key1_trig_topic = "sauna_ctrl/sauna_ctrl_key1/action"
key1_trig_payload = "key1_pressed"

key2_disc_topic = "homeassistant/device_automation/sauna_ctrl_key2/action_key2_press/config"
key2_disc_payload = {
    "automation_type": "trigger",
    "type": "action",
    "subtype": "key2_pressed",
    "payload": "key2_pressed",
    "topic": "sauna_ctrl/sauna_ctrl_key2/action",
    "device": {
        "identifiers": [
            "sauna_ctrl_key2"
        ]
    }
}
key2_trig_topic = "sauna_ctrl/sauna_ctrl_key2/action"
key2_trig_payload = "key2_pressed"

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
Font = ImageFont.truetype("/home/marcushj/sauna_ctrl/Inconsolata-Bold.ttf", 30)

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
    if msg.topic == tp_pwr_state:
        print("update power state")
        message_json = json.loads(msg.payload.decode())
        pwr_state = message_json.state
        print(pwr_state)
        draw.rectangle((130, 0, 240, 40), fill="BLACK")
        draw.text((130, 10), pwr_state.rjust(5), fill="WHITE", font=Font)
        im_r = image1.rotate(180)
        disp.ShowImage(im_r)

    if msg.topic == tp_t_0:
        print("update heater temp")
        draw.rectangle((130, 80, 240, 120), fill="BLACK")
        data = json.loads(msg.payload.decode())
        h_temp = float(data['temperature'])
        h_temp_str = "{:.1f}".format(h_temp)
        draw.text((130, 80), h_temp_str.rjust(5), fill="WHITE", font=Font)
        im_r = image1.rotate(180)
        disp.ShowImage(im_r)


    if msg.topic == tp_t_1:
        print("update ceiling temp")
        draw.rectangle((130, 150, 240, 190), fill="BLACK")
        data = json.loads(msg.payload.decode())
        h_temp = float(data['temperature'])
        h_temp_str = "{:.1f}".format(h_temp)
        draw.text((130, 150), h_temp_str.rjust(5), fill="WHITE", font=Font)
        im_r = image1.rotate(180)
        disp.ShowImage(im_r)

client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message

client.connect("fusion", 1883, 60)
client.loop_start()

client.publish(topic=key3_disc_topic, payload=str(key3_disc_payload), qos=2, retain=False)

p_key_u = 0
p_key_d = 0
p_key_l = 0
p_key_r = 0
p_key_p = 0
p_key1 = 0
p_key2 = 0
p_key3 = 0

try:
    while True:
        key3 = disp.digital_read(disp.GPIO_KEY3_PIN)
        key2 = disp.digital_read(disp.GPIO_KEY2_PIN)
        key1 = disp.digital_read(disp.GPIO_KEY1_PIN)
        key_u = disp.digital_read(disp.GPIO_KEY_UP_PIN)
        key_d = disp.digital_read(disp.GPIO_KEY_DOWN_PIN)
        key_l = disp.digital_read(disp.GPIO_KEY_LEFT_PIN)
        key_r = disp.digital_read(disp.GPIO_KEY_RIGHT_PIN)
        key_p = disp.digital_read(disp.GPIO_KEY_PRESS_PIN)
        if key3 != p_key3:
            p_key3 = key3
            if key3 == 1:
                print("key3 pressed - toggle power")
                client.publish(topic=key3_trig_topic, payload=str(key3_trig_payload), qos=1, retain=False)
        if key2 != p_key2:
            p_key2 = key2
            if key2 == 1:
                print("key2 pressed")
                client.publish(topic=key2_trig_topic, payload=str(key2_trig_payload), qos=1, retain=False)
        if key1 != p_key1:
            p_key1 = key1
            if key1 == 1:
                print("key1 pressed")
                client.publish(topic=key1_trig_topic, payload=str(key1_trig_payload), qos=1, retain=False)
        if key_u != p_key_u:
            p_key_u = key_u
            if key_u == 1:
                print("key up pressed")
                client.publish(topic=key_u_trig_topic, payload=str(key_u_trig_payload), qos=1, retain=False)
        if key_d != p_key_d:
            p_key_d = key_d
            if key_d == 1:
                print("key down pressed")
                client.publish(topic=key_d_trig_topic, payload=str(key_d_trig_payload), qos=1, retain=False)
        if key_l != p_key_l:
            p_key_l = key_l
            if key_l == 1:
                print("key left pressed")
                client.publish(topic=key_l_trig_topic, payload=str(key_l_trig_payload), qos=1, retain=False)
        if key_r != p_key_r:
            p_key_r = key_r
            if key_r == 1:
                print("key right pressed")
                client.publish(topic=key_r_trig_topic, payload=str(key_r_trig_payload), qos=1, retain=False)
        if key_p != p_key_p:
            p_key_p = key_p
            if key_p == 1:
                print("enter key pressed")
                client.publish(topic=key_p_trig_topic, payload=str(key_p_trig_payload), qos=1, retain=False)


except:
    print("exception")
client.loop_stop(force=False)
disp.module_exit()



