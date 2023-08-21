# 
# mqtt_client.py
#
# Andreas Holleland
# 2023
#

#---------------------------- PACKAGES -----------------------------------------

import paho.mqtt.client             as mqtt
import mqtt.mqtt_constants          as con
import state.sys_state              as state
import rms.rms_com                  as rms
import sample.sample                as sample
import cam.camera                   as cam
import data.images                  as imgs


#---------------------------- GLOBALS ------------------------------------------

clientname = "pis"
client = mqtt.Client(clientname)


# Topics subscribed to by the PIS
topics_sub = [

    # PIS control
    con.topic.CTRL_SAMPLE,
    con.topic.CTRL_IMAGE,
    con.topic.CTRL_SAMPLE_PUMP,
    con.topic.CTRL_STOP,
    con.topic.CAL_NEXTPOS,

    # RMS control
    con.topic.CTRL_RMS_FILL,
    con.topic.CTRL_RMS_FLUSH,
    con.topic.CTRL_RMS_STOP,

    # Image file system
    con.topic.GET_SAMPLES,
    con.topic.GET_IMAGES,
    con.topic.GET_IMAGE
    
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
        sample.set_sample_num(int(msg))
        state.set_sys_state(state.status_flag.READY, 0)
        state.set_sys_state(state.status_flag.SAMPLING, 1)


    # Manual control - 5v pump on/off
    if(topic == con.topic.CTRL_SAMPLE_PUMP):
        state.set_sys_state(state.status_flag.READY, 0)
        state.set_sys_state(state.status_flag.PUMP, 1)

    if(topic == con.topic.CTRL_STOP):
        state.set_sys_state(state.status_flag.READY, 1)
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
        state.set_sys_state(state.status_flag.READY, 0)
        state.set_sys_state(state.status_flag.IMAGING, 1)


    # Camera calibration - new position
    if(topic == con.topic.CAL_NEXTPOS):
        cam.set_pos(int(msg))
        state.set_sys_state(state.status_flag.READY, 0)
        state.set_sys_state(state.status_flag.CALIBRATING, 1)

    # Camera calibration - new LED brightness
    if(topic == con.topic.CAL_NEXTLED):
        cam.setLed(int(msg))
        state.set_sys_state(state.status_flag.READY, 0)
        state.set_sys_state(state.status_flag.CALIBRATING, 1)


    # Images file system
    if(topic == con.topic.GET_SAMPLES):
        imgs.get_samples()

    if(topic == con.topic.GET_IMAGES):
        imgs.set_curr_sample(msg)

    if(topic == con.topic.GET_IMAGE):
        imgs.set_curr_image(msg)


# Publish current system state to status topic
def pub_status():
    client.publish(
        topic   = con.topic.STATUS_FLAGS, 
        payload = state.get_sys_state(), 
        qos     = 1, 
        retain  = True
    )


# Publish current camera position
def pub_cam_pos(pos):
    client.publish(
        topic   = con.topic.CAL_CURRPOS, 
        payload = pos, 
        qos     = 1, 
        retain  = True
    )


# Publish current LED brightness
def pub_led_brightness(brightness):
        client.publish(
        topic   = con.topic.CAL_CURRLED, 
        payload = brightness, 
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


# Publish sample times to samples topic
def pub_sample_times(sample_times):
    client.publish(
        topic   = con.topic.DATA_SAMPLES, 
        payload = sample_times, 
        qos     = 1, 
        retain  = True
    )


# Publish image times of a sample to images topic
def pub_image_times(image_times):
    client.publish(
        topic   = con.topic.DATA_IMAGES, 
        payload = image_times, 
        qos     = 1, 
        retain  = True
    )


# Publish image corresponding to an image time
def pub_image(image):
    client.publish(
        topic   = con.topic.DATA_IMAGE, 
        payload = image, 
        qos     = 1, 
        retain  = True
    )