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

clientname = "pscope_pis"
client = mqtt.Client(client_id=clientname, clean_session=True)


# Topics subscribed to by the PIS
topics_sub = [

    # PIS control
    con.topic.CTRL_SAMPLE,
    con.topic.CTRL_IMAGE,
    con.topic.CTRL_SAMPLE_PUMP,
    con.topic.CTRL_STOP,

    # PIS calibration
    con.topic.CAL_NEXTPOS,
    con.topic.CAL_NEXTLED,

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

# --- Initialize MQTT client thread ---
def init_mqtt_thread():
    
    # Set callbacks
    client.on_connect = on_connect
    client.on_message = on_message

    # Set last-will topic
    client.will_set(
        con.topic.STATUS_CONNECTED, 0, 1, True
    )

    # Connect and start thread
    client.connect(con.broker)
    client.loop_start()


# --- On-connect callback function ---
def on_connect(client, userdata, flags, rc):

    # If connection succeeds
    if(rc == 0):
        # Publish to connected topic
        client.publish(
            con.topic.STATUS_CONNECTED, 1, 1, True
        )

    # If connection fails
    else:
        #print("Connection failed, returned code: ", rc)
        pass

    # Subscribe to relevant topics with QOS=1
    for topic in topics_sub:
        client.subscribe(topic, 1)


# --- On-message received callback function ---
def on_message(client, userdata, message):
    msg = message.payload
    topic = message.topic
    msg_handler(topic, msg)


# --- Filter incoming topics/messages in on_message callback ---
def msg_handler(topic, msg):

    # Sample
    if(topic == con.topic.CTRL_SAMPLE):
        handle_sample(msg)

    # Pump on
    if(topic == con.topic.CTRL_SAMPLE_PUMP):
        handle_pump(msg)

    # Pump off
    if(topic == con.topic.CTRL_STOP):
        handle_stop(msg)

    # RMS FILL
    if(topic == con.topic.CTRL_RMS_FILL):
        handle_rms_fill(msg)

    # RMS FLUSH
    if(topic == con.topic.CTRL_RMS_FLUSH):
        handle_rms_flush(msg)

    # RMS STOP (force IDLE)
    if(topic == con.topic.CTRL_RMS_STOP):
        handle_rms_stop(msg)

    # Capture image
    if(topic == con.topic.CTRL_IMAGE):
        handle_cal_image(msg)

    # Lens position
    if(topic == con.topic.CAL_NEXTPOS):
        handle_lens(msg)

    # Led brightness
    if(topic == con.topic.CAL_NEXTLED):
        handle_led(msg)

    # List of samples
    if(topic == con.topic.GET_SAMPLES):
        handle_samples(msg)

    # List of images from sample
    if(topic == con.topic.GET_IMAGES):
        handle_images(msg)

    # Image from sample
    if(topic == con.topic.GET_IMAGE):
        handle_image(msg)


# --- MESSAGE HANDLERS ---

# Sample
def handle_sample(msg):
    if((state.get_sys_state() >> state.status_flag.READY) & 1):
        sample.set_sample_num(int(msg))
        state.set_sys_state(state.status_flag.READY, 0)
        state.set_sys_state(state.status_flag.SAMPLING, 1)

# Pump on
def handle_pump(msg):
    if((state.get_sys_state() >> state.status_flag.READY) & 1):
        state.set_sys_state(state.status_flag.READY, 0)
        state.set_sys_state(state.status_flag.PUMP, 1)

# Pump off
def handle_stop(msg):
    if((state.get_sys_state() >> state.status_flag.SAMPLING) & 1):
        pass
    elif((state.get_sys_state() >> state.status_flag.PUMP) & 1):
        state.set_sys_state(state.status_flag.READY, 1)
        state.set_sys_state(state.status_flag.PUMP, 0)

# RMS FILL
def handle_rms_fill(msg):
    if((state.get_sys_state() >> state.status_flag.READY) & 1):
        rms.send_fill()

# RMS FLUSH
def handle_rms_flush(msg):
    if((state.get_sys_state() >> state.status_flag.READY) & 1):
        rms.send_flush()

# RMS STOP (force IDLE)
def handle_rms_stop(msg):
    if((state.get_sys_state() >> state.status_flag.READY) & 1):
        rms.send_stop()

# Capture image
def handle_cal_image(msg):
    if((state.get_sys_state() >> state.status_flag.READY) & 1):
        state.set_sys_state(state.status_flag.READY, 0)
        state.set_sys_state(state.status_flag.IMAGING, 1)

# Lens position
def handle_lens(msg):
    cam.set_pos(int(msg))
    state.set_sys_state(state.status_flag.READY, 0)
    state.set_sys_state(state.status_flag.CALIBRATING, 1)

# LED Brightness
def handle_led(msg):
    cam.setLed(float(msg))
    state.set_sys_state(state.status_flag.READY, 0)
    state.set_sys_state(state.status_flag.CALIBRATING, 1)

# List of samples
def handle_samples(msg):
    imgs.send_samples()

# List of images from sample
def handle_images(msg):
    imgs.set_curr_sample(msg)

# Image from sample
def handle_image(msg):
    imgs.set_curr_image(msg)


# --- PUBLISHERS ---

# Publish current system state to status topic
def pub_status():
    client.publish(con.topic.STATUS_FLAGS, state.get_sys_state(), 1, True)


# Publish current camera position
def pub_cam_pos(pos):
    client.publish(con.topic.CAL_CURRPOS, pos, 1, True)


# Publish current LED brightness
def pub_led_brightness(brightness):
    client.publish(con.topic.CAL_CURRLED, brightness, 1, True)


# Publish an image to photo topic
def pub_photo(picture):
    client.publish(con.topic.IMAGE, picture, 1, True)


# Publish sample times to samples topic
def pub_sample_times(sample_times):
    client.publish(con.topic.DATA_SAMPLES, sample_times, 1, True)


# Publish image times of a sample to images topic
def pub_image_times(image_times):
    client.publish(con.topic.DATA_IMAGES, image_times, 1, True)


# Publish image corresponding to an image time
def pub_image(image):
    client.publish(con.topic.DATA_IMAGE, image, 1, True)