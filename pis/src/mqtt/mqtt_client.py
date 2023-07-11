# 
# mqtt_client.py
#
# Andreas Holleland
# 2023
#

#---------------------------- PACKAGES -----------------------------------------

import paho.mqtt.client             as mqtt
import mqtt_client.mqtt_constants   as con
import state.sys_state              as state
import rms.rms_com                  as rms
import sample.sample                as sample
import cam.camera                   as cam


#---------------------------- GLOBALS ------------------------------------------

clientname = "pis"
client = mqtt.Client(clientname)


# Topics subscribed to by the PIS
topics_sub = [
    con.topic.CTRL_SAMPLE,
    con.topic.CTRL_IMAGE,
    con.topic.CTRL_SAMPLE_PUMP,
    con.topic.CTRL_STOP,
    con.topic.CAL_NEXTPOS,
    con.topic.CTRL_RMS_FILL,
    con.topic.CTRL_RMS_FLUSH,
    con.topic.CTRL_RMS_STOP
]


#---------------------------- FUNCTIONS ----------------------------------------

# Initialize MQTT client thread
def init_mqtt_thread():
    
    # Set callbacks
    client.on_connect = on_connect
    client.on_message = on_message

    # Set last-will topic
    client.will_set(
        topic = con.topic.STATUS_CONNECTED,
        payload = 0,
        qos = 1,
        retain = True
    )

    # Connect and start thread
    client.connect(con.broker)
    client.loop_start()


# On-connect callback function
def on_connect(client, userdata, flags, rc):

    # If connection succeeds
    if(rc == 0):
        # Publish to connected topic
        client.publish(
            topic = con.topic.STATUS_CONNECTED, 
            payload = 1, 
            qos = 1,
            retain = True
        )

    # If connection fails
    else:
        print("Connection failed, returned code: ", rc)

    # Subscribe to relevant topics with QOS=1
    for topic in topics_sub:
        client.subscribe(topic, 1)


# On-message received callback function
def on_message(client, userdata, message):
    msg = message.payload
    topic = message.topic
    msg_handler(topic, msg)


# Filter incoming messages in on_message callback
def msg_handler(topic, msg):

    # Begin sample routine
    if(topic == con.topic.CTRL_SAMPLE):
        state.set_sys_state(state.status_flag.SAMPLING, 1)
        sample.set_sample_num(int(msg))

    # Manual control - 5v pump on/off
    if(topic == con.topic.CTRL_SAMPLE_PUMP):
        state.set_sys_state(state.status_flag.PUMP, 1)
    if(topic == con.topic.CTRL_STOP):
        state.set_sys_state(state.status_flag.PUMP, 0)

    # Manual control - RMS fill, flush, stop
    if(topic == con.topic.CTRL_RMS_FILL):
        rms.send_fill()
    if(topic == con.topic.CTRL_RMS_FLUSH):
        rms.send_flush()
    if(topic == con.topic.CTRL_RMS_STOP):
        rms.send_stop()

    # Manual control - capture new image and publish
    if(topic == con.topic.CTRL_IMAGE):
        state.set_sys_state(state.status_flag.IMAGING, 1)

    # Camera calibration - new position
    if(topic == con.topic.CAL_NEXTPOS):
        state.set_sys_state(state.status_flag.CALIBRATING, 1)
        


# Publish current system state to status topic
def pub_status():
    client.publish(
        topic   = con.topic.STATUS_FLAGS, 
        payload = state.get_sys_state(), 
        qos     = 1, 
        retain  = True
    )


# Publish an image to photo topic
def pub_photo(picture):
    client.publish(
        topic   = con.topic.IMAGE, 
        payload = picture, 
        qos     = 1, 
        retain  = True
    )

