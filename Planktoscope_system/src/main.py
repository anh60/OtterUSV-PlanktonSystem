# 
# main.py
#
# Andreas Holleland
# 2023
#

#---------------------------- PACKAGES -----------------------------------------

import asyncio
import STATUS.status            as state
import MQTT_CLIENT.mqtt_client  as client
import RMS_COM.rms_com          as rms


#---------------------------- FUNCTIONS ----------------------------------------

async def mainloop():
    if(state.update_sys_state()):
        client.pub_status()
        print("Sending new state: " + str(state.get_sys_state()))


#---------------------------- INIT ---------------------------------------------

state.init_state()
client.init_mqtt()
rms.init_comms()


#---------------------------- LOOP ---------------------------------------------

while True:
    asyncio.run(mainloop())


#-------------------------------------------------------------------------------


if __name__ == '__main__':
    pass