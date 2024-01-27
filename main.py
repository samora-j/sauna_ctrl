import spidev as SPI
import logging
import ST7789
import time
import paho.mqtt.client as mqtt

from PIL import Image,ImageDraw,ImageFont


# topic
# zigbee2mqtt/0xe0798dfffe57ec82/set

logging.basicConfig(level=logging.DEBUG)
# 240x240 display with hardware SPI:
disp = ST7789.ST7789()

# Initialize library.
disp.Init()
disp.clear()
disp.bl_DutyCycle(50)

# Create blank image for drawing.
image1 = Image.new("RGB", (disp.width, disp.height), "BLACK")
draw = ImageDraw.Draw(image1)

FVB = ImageFont.truetype("VolvoBroad.ttf", 50)

draw.text((5, 68), 'Hello world', fill="WHITE", font=FVB)
im_r = image1.rotate(180)
disp.ShowImage(im_r)


# The callback for when the client receives a CONNACK response from the server.
def on_connect(client, userdata, flags, rc):
    print("Connected with result code "+str(rc))

    # Subscribing in on_connect() means that if we lose the connection and
    # reconnect then subscriptions will be renewed.
    client.subscribe("zigbee2mqtt/0xe0798dfffe57ec82/set/#")

# The callback for when a PUBLISH message is received from the server.
def on_message(client, userdata, msg):
    print(msg.topic+" "+str(msg.payload))

client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message

client.connect("fusion", 1883, 60)

# Blocking call that processes network traffic, dispatches callbacks and
# handles reconnecting.
# Other loop*() functions are available that give a threaded interface and a
# manual interface.
client.loop_forever()
