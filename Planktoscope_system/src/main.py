# 
# main.py
#
# Andreas Holleland
# 2023
#

#---------------------------- PACKAGES -----------------------------------------

import asyncio
import STATUS.status as state
import MQTT_CLIENT.mqtt_client as client


#---------------------------- FUNCTIONS ----------------------------------------

async def mainloop():
    if(state.update_sys_state()):
        client.pub_status()
        print("Command received, sending new state: " + bin(state.get_sys_state()))


#---------------------------- INIT ---------------------------------------------

state.init_state()
client.init_mqtt()


#---------------------------- LOOP ---------------------------------------------

while True:
    asyncio.run(mainloop())


#-------------------------------------------------------------------------------


if __name__ == '__main__':
    pass