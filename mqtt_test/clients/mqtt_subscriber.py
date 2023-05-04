import paho.mqtt.client as mqtt
import globals

t = globals.topics
qos = 0

def on_connect(client, userdata, flags, rc):
    client.subscribe([
        (t[0], qos), 
        (t[1], qos),
        (t[2], qos),
        (t[3], qos)
    ])

def on_message(client, userdata, message):
    msg = message.payload
    print(str(msg.decode("utf-8")))

def init_sub():
    client = mqtt.Client("planktopi_sub")
    client.on_connect = on_connect
    client.on_message = on_message
    client.connect(globals.broker)
    client.loop_start()
