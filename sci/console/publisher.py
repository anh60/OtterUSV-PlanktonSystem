import asyncio

import paho.mqtt.client as mqtt
import mqtt_constants as con

client = mqtt.Client("planktopi_pub")

async def pub():
    choice = input()

    if(choice == '1'):
        client.publish(
            topic = con.topic.STATUS_FLAGS, 
            payload = 0, 
            qos = 1,
            retain = True
            )
        print("Publishing: 1")
        print("")

    if(choice == '2'):
        client.publish(
            topic = con.topic.STATUS_FLAGS, 
            payload = 1, 
            qos = 1,
            retain = True
            )
        print("Publishing: 1")
        print("")

    if(choice == '3'):
        client.publish(
            topic = con.topic.STATUS_FLAGS, 
            payload = 2, 
            qos = 1,
            retain = True
            )
        print("Publishing: 2")
        print("")

def on_connect(client, userdata, flags, rc):
    client.publish(
        topic = con.topic.STATUS_CONNECTED, 
        payload = 1, 
        qos = 1,
        retain = True
    )

client.on_connect = on_connect

client.will_set(
    topic = con.topic.STATUS_CONNECTED,
    payload = 0,
    qos = 1,
    retain = True
)

client.connect(con.broker)
client.loop_start()

while True:
    asyncio.run(pub())

