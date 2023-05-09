#
# pubsub.py
#
# Andreas Holleland
# 2023
#

#---------------------------- PACKAGES -----------------------------------------

import asyncio
import paho.mqtt.client as mqtt
import mqtt_constants as con


#---------------------------- GLOBALS ------------------------------------------

client = mqtt.Client("planktopi_pubsub")


#---------------------------- FUNCTIONS ----------------------------------------

async def pub():
    client.publish(con.topic.SAMPLE, "sample")
    print("Publishing: 1\n")
    await asyncio.sleep(1)
    print("Publishing: 0\n")
    client.publish(con.topic.POS, "position")
    await asyncio.sleep(1)


def on_connect(client, userdata, flags, rc):
    client.subscribe(con.topic.STATUS, 0)


def on_message(client, userdata, message):
    msg = message.payload
    print("Received new state: ")
    print(msg)
    print("\n")


def init_sub():
    client = mqtt.Client("planktopi_sub")
    client.on_connect = on_connect
    client.on_message = on_message
    client.connect(con.broker)
    client.loop_start()


#---------------------------- INIT ---------------------------------------------

init_sub()
client.connect(con.broker)

while True:
    asyncio.run(pub())