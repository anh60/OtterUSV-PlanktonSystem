import paho.mqtt.client as mqtt
import time
import globals

client = mqtt.Client("planktopi_pub")

client.connect(globals.broker)

t = globals.topics

while True:
    client.publish(t[0], "planktopi topic one")
    time.sleep(1)
    client.publish(t[1], "planktopi topic two")
    time.sleep(1)
    client.publish(t[2], "planktopi topic three")
    time.sleep(1)
    client.publish(t[3], "planktopi topic four")
    time.sleep(1)