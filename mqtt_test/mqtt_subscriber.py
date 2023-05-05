import paho.mqtt.client as mqtt
import mqtt_constants as con

qos = 0

def on_connect(client, userdata, flags, rc):
    client.subscribe([
        (con.topic.STATUS, qos)
    ])

def on_message(client, userdata, message):
    msg = message.payload
    print(str(msg.decode("utf-8")))

def init_sub():
    client = mqtt.Client("planktopi_sub")
    client.on_connect = on_connect
    client.on_message = on_message
    client.connect(con.broker)
    client.loop_start()

init_sub()

while True:
    lekna = 1
