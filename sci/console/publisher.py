import asyncio

import paho.mqtt.client as mqtt
import mqtt_constants as con

client = mqtt.Client("planktopi_pub")


async def pub():
    client.publish(con.topic.SAMPLE, "sample")
    print("Publishing: 1\n")
    await asyncio.sleep(1)
    print("Publishing: 0\n")
    client.publish(con.topic.POS, "position")
    await asyncio.sleep(1)


client.connect(con.broker)

while True:
    asyncio.run(pub())

