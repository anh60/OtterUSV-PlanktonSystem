import paho.mqtt.client as mqtt
import time
import mqtt_constants as con

client = mqtt.Client("planktopi_pub")

client.connect(con.broker)

while True:
    client.publish(con.topic.SAMPLE, "sample please")
    time.sleep(1)
    client.publish(con.topic.POS, "position")
    time.sleep(1)