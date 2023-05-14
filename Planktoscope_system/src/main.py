# 
# main.py
#
# Andreas Holleland
# 2023
#

#---------------------------- PACKAGES -----------------------------------------

import asyncio
import STATUS.status            as state
import RMS_COM.rms_com          as rms
import MQTT_CLIENT.mqtt_client  as client


#---------------------------- FUNCTIONS ----------------------------------------

async def mainloop():
    if(state.update_sys_state()):
        client.pub_status()


#---------------------------- INIT ---------------------------------------------

state.init_state()
rms.init_comms()
client.init_mqtt()

rms.send_status_request()
client.pub_status()


#---------------------------- LOOP ---------------------------------------------

while True:
    asyncio.run(mainloop())


#-------------------------------------------------------------------------------


if __name__ == '__main__':
    pass