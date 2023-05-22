# 
# main.py
#
# Andreas Holleland
# 2023
#

#---------------------------- PACKAGES -----------------------------------------

import asyncio
import threading
import time

import STATUS.status            as state
#import RMS_COM.rms_com          as rms
import MQTT_CLIENT.mqtt_client  as client


#---------------------------- FUNCTIONS ----------------------------------------

async def sample():
    print("Sampling started\n")
    #rms.send_pump()
    await asyncio.sleep(5.0)
    print("Sampling finished\n")
    #rms.send_stop()
    state.set_sys_state(state.status_flag.SAMPLING, 0)


def status_pub_thread():
    while True:
        if(state.update_sys_state()):
            client.pub_status()
        


#---------------------------- INIT ---------------------------------------------

state.init_state()
#rms.init_comms()
client.init_mqtt()

#rms.send_status_request()
client.pub_status()

status_thread = threading.Thread(target = status_pub_thread)
status_thread.daemon = True
status_thread.start()


#---------------------------- LOOP ---------------------------------------------

while True:
    if((state.get_sys_state() >> state.status_flag.SAMPLING) & 1):
        asyncio.run(sample())


#-------------------------------------------------------------------------------


if __name__ == '__main__':
    pass