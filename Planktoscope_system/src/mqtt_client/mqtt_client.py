# mqtt_client.py
#
# Andreas Holleland
# 2023
#

import paho.mqtt.client as mqtt
import mqtt_client.mqtt_constants as con

clientname = "planktopi"
client = mqtt.Client(clientname)

topics_sub = [
    con.topic.SAMPLE,
    con.topic.POS
]

def init_mqtt():
    client.on_connect = on_connect
    client.on_message = on_message
    client.connect(con.broker)
    client.loop_start()

def on_connect(client, userdata, flags, rc):
    qos = 0
    for topic in topics_sub:
        client.subscribe(topic, qos)

def on_message(client, userdata, message):
    msg = message.payload
    msg_handler(msg)

def msg_handler(msg):
    print(str(msg.decode("utf-8")))

def pub_status(status):
    client.publish(con.topic.STATUS, status)

