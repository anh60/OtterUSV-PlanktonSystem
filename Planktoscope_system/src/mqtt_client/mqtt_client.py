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
    con.topic.CTRL_SAMPLE,
    con.topic.CAL_NEXTPOS,
    con.topic.CTRL_RMS_PUMP,
    con.topic.CTRL_RMS_VALVE,
    con.topic.CTRL_RMS_STOP
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
        state.set_sys_state(state.status_flag.CONNECTED, 0)

    else:
        print("Connection failed, returned code: ", rc)

    for topic in topics_sub:
        client.subscribe(topic, 1)


def on_message(client, userdata, message):
    msg = message.payload
    topic = message.topic
    msg_handler(topic, msg)


def msg_handler(topic, msg):

    if(topic == con.topic.CTRL_SAMPLE):
        state.set_sys_state(state.status_flag.SAMPLING, 1)

    if(topic == con.topic.CTRL_RMS_PUMP):
        rms.send_pump()

    if(topic == con.topic.CTRL_RMS_VALVE):
        rms.send_flush()

    if(topic == con.topic.CTRL_RMS_STOP):
        rms.send_stop()

    if(topic == con.topic.CAL_NEXTPOS):
        state.set_sys_state(state.status_flag.CALIBRATING, 1)


def pub_status():
    client.publish(
        topic   = con.topic.STATUS_FLAGS, 
        payload = state.get_sys_state(), 
        qos     = 1, 
        retain  = True
    )

def pub_photo(picture):
    client.publish(
        topic   = con.topic.CAL_PHOTO, 
        payload = picture, 
        qos     = 1, 
        retain  = False
    )

