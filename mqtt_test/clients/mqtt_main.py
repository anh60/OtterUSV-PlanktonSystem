import mqtt_subscriber as sub
import threading
import asyncio

async def test():
    print("async function")
    await asyncio.sleep(3)

sub.init_sub()

while True:
    asyncio.run(test())