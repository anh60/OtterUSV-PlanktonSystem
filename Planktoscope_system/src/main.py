# 
# main.py
#
# Andreas Holleland
# 2023
#

#---------------------------- PACKAGES -----------------------------------------

import asyncio
import threading

import STATUS.status            as state
import RMS_COM.rms_com          as rms
import MQTT_CLIENT.mqtt_client  as client
import base64

import time
import board
from adafruit_motorkit import MotorKit

kit = MotorKit(i2c=board.I2C())


#---------------------------- FUNCTIONS ----------------------------------------

async def sample():
    print("Sampling started\n")
    rms.send_pump()
    await asyncio.sleep(5.0)
    print("Sampling finished\n")
    rms.send_stop()
    state.set_sys_state(state.status_flag.SAMPLING, 0)

async def calibrate():
    print("Calibration started\n")

    with open("image.jpg", "rb") as image:
        img = image.read()
    
    message = img 
    base64_bytes = base64.b64encode(message)
    base64_message = base64_bytes.decode('ascii')

    client.pub_photo(base64_message)

    print("Calibration finished\n")
    state.set_sys_state(state.status_flag.CALIBRATING, 0)

async def samplePump():
    kit.motor3.throttle = -1.0


def status_pub_thread():
    while True:
        if(state.update_sys_state()):
            client.pub_status()
            print(state.get_sys_state())


#---------------------------- INIT ---------------------------------------------

state.init_state()
rms.init_comms()
client.init_mqtt()

rms.send_status_request()
client.pub_status()

status_thread = threading.Thread(target = status_pub_thread)
status_thread.daemon = True
status_thread.start()


#---------------------------- LOOP ---------------------------------------------

# note: maybe change to threading instead of async functions,
#       as extracting/publishing image file may be computationally intensive
#
# note: Considering the above, figure out how to execute and kill threads
#       on command (at the moment threads can only run forever)

while True:
    if((state.get_sys_state() >> state.status_flag.SAMPLING) & 1):
        asyncio.run(sample())

    if((state.get_sys_state() >> state.status_flag.CALIBRATING) & 1):
        asyncio.run(calibrate())

    if((state.get_sys_state() >> state.status_flag.PUMP) & 1):
        asyncio.run(samplePump())
    else:
        kit.motor3.throttle = 0


#-------------------------------------------------------------------------------


if __name__ == '__main__':
    pass