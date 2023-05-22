import asyncio
from enum import Enum
from struct import *

import paho.mqtt.client as mqtt
import mqtt_constants as con

client = mqtt.Client("planktopi_pub")

sys_state = 0

class status_flag(int, Enum):
    RMS_PUMP    = 0
    RMS_VALVE   = 1
    RMS_FULL    = 2
    RMS_LEAK    = 3
    CONNECTED   = 4
    SAMPLING    = 5
    LEAK        = 6

async def pub():
    global sys_state

    choice = input()

    if(choice == '1'):
        client.publish(con.topic.SAMPLE, "sample", 1)
        print("Publishing: 1")
        print("")

    if(choice == '2'):
        print("Publishing: 0")
        print("")

    if(choice == '3'):
        print("")
        print("sys_state : " + bin(sys_state))
        print("RMS_PUMP  : ", str((sys_state >> 0) & 1))
        print("RMS_VALVE : ", str((sys_state >> 1) & 1))
        print("RMS_FULL  : ", str((sys_state >> 2) & 1))
        print("RMS_LEAK  : ", str((sys_state >> 3) & 1))
        print("CONNECTED : ", str((sys_state >> 4) & 1))
        print("SAMPLING  : ", str((sys_state >> 5) & 1))
        print("LEAK      : ", str((sys_state >> 6) & 1))
        print("X         : ", str((sys_state >> 7) & 1))
        print("")

def on_connect(client, userdata, flags, rc):
    client.subscribe(con.topic.STATUS, 1)


def on_message(client, userdata, message):
    global sys_state
    msg = message.payload
    print("")
    print("Received new state: " + str(msg))
    print("")
    sys_state = int(msg)


def init_sub():
    client.on_connect = on_connect
    client.on_message = on_message
    client.connect(con.broker)
    client.loop_start()


init_sub()
client.connect(con.broker)

while True:
    asyncio.run(pub())