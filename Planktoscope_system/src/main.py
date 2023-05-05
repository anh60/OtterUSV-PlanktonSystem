# main.py
#
# Andreas Holleland
# 2023
#

import asyncio
import mqtt_client.mqtt_client as cli

SYS_STATUS = 0x64

async def pub():
    cli.pub_status(SYS_STATUS)
    await asyncio.sleep(3)

#SETUP
cli.init_mqtt()

#LOOP
while True:
    asyncio.run(pub())

if __name__ == '__main__':
    pass
