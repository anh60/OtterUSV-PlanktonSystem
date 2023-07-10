# 
# main.py
#
# Andreas Holleland
# 2023
#

#---------------------------- PACKAGES -----------------------------------------

import asyncio
import threading
import base64

import state.sys_state              as state
import rms.rms_com                  as rms
import mqtt_client.mqtt_client      as client
import sample.sample                as sample

#import board
#from adafruit_motorkit import MotorKit

#kit = MotorKit(i2c=board.I2C())


#---------------------------- FUNCTIONS ----------------------------------------

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


def status_pub_thread():
    while True:
        if(state.update_sys_state()):
            client.pub_status()
            print(state.get_sys_state())


#---------------------------- INIT ---------------------------------------------

state.init_state()              # State handler
rms.init_comms()                # RMS communication
client.init_mqtt()              # MQTT client
sample.init_sample_thread()     # Sample thread

status_thread = threading.Thread(target = status_pub_thread)
status_thread.daemon = True
status_thread.start()

rms.send_status_request()


#---------------------------- LOOP ---------------------------------------------

#async def samplePump():
#    kit.motor3.throttle = -1.0

while True:
    if((state.get_sys_state() >> state.status_flag.CALIBRATING) & 1):
        asyncio.run(calibrate())

    #if((state.get_sys_state() >> state.status_flag.PUMP) & 1):
    #    asyncio.run(samplePump())
    #else:
    #    kit.motor3.throttle = None


#-------------------------------------------------------------------------------


if __name__ == '__main__':
    pass