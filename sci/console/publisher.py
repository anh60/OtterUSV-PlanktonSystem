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

""""
curr_sys_status = 0
next_sys_status = 0

#-------------------------------------------------------------------------------

def on_connect(client, userdata, flags, rc):
    client.subscribe(con.topic.STATUS, 0)

def on_message(client, userdata, message):
    global next_sys_status
    msg = message.payload

def init_sub():
    client.on_connect = on_connect
    client.on_message = on_message
    client.connect(con.broker)
    client.loop_start()

def menu():
    global curr_sys_status
    print("\n")
    print("System status: " + bin(curr_sys_status))

    print("What would you like to do?")

    print("1:   Send SAMPLE command \n" +
          "2:   Send POS command\n"
    )

async def send():
    client.publish(con.topic.SAMPLE, "sample")
    asyncio.sleep(2)
    client.publish(con.topic.POS, "pos")
    asyncio.sleep(2)

async def userinput():
    choice = input("Enter choice ")
    if(choice == '1'):
        client.publish(con.topic.SAMPLE, "sample")
    if(choice == '2'):
        client.publish(con.topic.POS, "pos")
"""

