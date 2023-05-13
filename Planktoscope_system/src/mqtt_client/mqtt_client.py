# 
# mqtt_client.py
#
# Andreas Holleland
# 2023
#

#---------------------------- PACKAGES -----------------------------------------

import paho.mqtt.client             as mqtt
import MQTT_CLIENT.mqtt_constants   as con
import STATUS.status                as state
import RMS_COM.rms_com              as rms


#---------------------------- GLOBALS ------------------------------------------

clientname = "planktopi"
client = mqtt.Client(clientname)

topics_sub = [
    con.topic.SAMPLE,
    con.topic.POS
]


#---------------------------- FUNCTIONS ----------------------------------------

def init_mqtt():
    client.on_connect = on_connect
    client.on_message = on_message
    client.connect(con.broker)
    client.loop_start()


def on_connect(client, userdata, flags, rc):
    if(rc == 0):
        print("Connected to broker")
    else:
        print("Connection failed, returned code: ", rc)

    for topic in topics_sub:
        client.subscribe(topic, 0)


def on_message(client, userdata, message):
    msg = message.payload
    topic = message.topic
    msg_handler(topic, msg)


def msg_handler(topic, msg):

    if(topic == con.topic.SAMPLE):
        state.set_sys_state(state.status_flag.SAMPLING, 1)
        rms.send_pump()

    # just for testing!!!
    if(topic == con.topic.POS):
        state.set_sys_state(state.status_flag.SAMPLING, 0)
        rms.send_stop()


def pub_status():
    client.publish(
        topic   = con.topic.STATUS, 
        payload = state.get_sys_state(), 
        qos     = 0, 
        retain  = True
    )

