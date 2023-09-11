# 
# sys_state.py
#
# Andreas Holleland
# 2023
#

#---------------------------- PACKAGES -----------------------------------------

from enum import Enum
import threading
import time

import mqtt.mqtt_client as client
import sample.sample    as sample
import rms.rms_com      as rms
import cam.camera       as cam
import data.images      as imgs


#---------------------------- GLOBALS ------------------------------------------

# Flag bytes
curr_sys_state = 0
next_sys_state = 0


# Flags
class status_flag(int, Enum):
    
    # RMS
    RMS_PUMP        = 0
    RMS_VALVE       = 1
    RMS_FULL        = 2
    RMS_LEAK        = 3

    # PIS
    READY           = 4
    SAMPLING        = 5
    PUMP            = 6
    IMAGING         = 7
    CALIBRATING     = 8
    LEAK            = 9


#---------------------------- FUNCTIONS ----------------------------------------

# --- Get sys state (flags) ---
def get_sys_state():
    global curr_sys_state, next_sys_state
    return curr_sys_state


# --- Set/clear a flag ---
def set_sys_state(flag, val):
    global curr_sys_state, next_sys_state
    if(val == 1):
        next_sys_state |= (1 << flag)
    else:
        next_sys_state &= (~(1 << flag))

# --- Vehicle position ---
def handle_pos(msg):
    sample.set_sample_pos(msg)


# --- Sample ---
def handle_sample(msg):
    if((get_sys_state() >> status_flag.READY) & 1):
        try:
            sample.set_sample_num(int(msg))
            set_sys_state(status_flag.SAMPLING, 1)
        except:
            pass


# --- Pump on ---
def handle_pump(msg):
    if((get_sys_state() >> status_flag.READY) & 1):
        set_sys_state(status_flag.PUMP, 1)


# --- Pump off ---
def handle_stop(msg):
    if((get_sys_state() >> status_flag.SAMPLING) & 1):
        pass
    elif((get_sys_state() >> status_flag.PUMP) & 1):
        set_sys_state(status_flag.PUMP, 0)


# --- RMS FILL ---
def handle_rms_fill(msg):
    if((get_sys_state() >> status_flag.READY) & 1):
        rms.send_fill()


# --- RMS FLUSH ---
def handle_rms_flush(msg):
    if((get_sys_state() >> status_flag.READY) & 1):
        rms.send_flush()


# --- RMS STOP (force IDLE) ---
def handle_rms_stop(msg):
    if((get_sys_state() >> status_flag.READY) & 1):
        rms.send_stop()


# --- Capture image ---
def handle_cal_image(msg):
    if((get_sys_state() >> status_flag.READY) & 1):
        set_sys_state(status_flag.IMAGING, 1)


# --- Lens position ---
def handle_lens(msg):
    try:
        cam.set_lens_position(int(msg))
        set_sys_state(status_flag.CALIBRATING, 1)
    except:
        pass


# --- LED Brightness ---
def handle_led(msg):
    try:
        cam.set_led_brightness(float(msg))
        set_sys_state(status_flag.CALIBRATING, 1)
    except:
        pass


# --- List of samples ---
def handle_samples(msg):
    imgs.publish_samples()


# --- List of images from sample ---
def handle_images(msg):
    imgs.set_curr_sample(msg)


# --- Image from sample ---
def handle_image(msg):
    imgs.set_curr_image(msg)


# --- Handle MQTT message ---
def handle_mqtt_msg(topic, msg):
    if(topic == client.con.topic.VEHICLE_POS):
        handle_pos(msg)
    if(topic == client.con.topic.CTRL_SAMPLE):
        handle_sample(msg)
    if(topic == client.con.topic.CTRL_SAMPLE_PUMP):
        handle_pump(msg)
    if(topic == client.con.topic.CTRL_STOP):
        handle_stop(msg)
    if(topic == client.con.topic.CTRL_RMS_FILL):
        handle_rms_fill(msg)
    if(topic == client.con.topic.CTRL_RMS_FLUSH):
        handle_rms_flush(msg)
    if(topic == client.con.topic.CTRL_RMS_STOP):
        handle_rms_stop(msg)
    if(topic == client.con.topic.CTRL_IMAGE):
        handle_cal_image(msg)
    if(topic == client.con.topic.CAL_NEXTPOS):
        handle_lens(msg)
    if(topic == client.con.topic.CAL_NEXTLED):
        handle_led(msg)
    if(topic == client.con.topic.GET_SAMPLES):
        handle_samples(msg)
    if(topic == client.con.topic.GET_IMAGES):
        handle_images(msg)
    if(topic == client.con.topic.GET_IMAGE):
        handle_image(msg)


# --- Check MQTT message queue ---
def check_mqtt_queue():
    topics, msgs = client.get_msgs()
    if(len(topics) > 0):
        handle_mqtt_msg(topics[0], msgs[0])
        client.dequeue_msgs()
        

# --- Check for a state change ---
def check_sys_state():
    global curr_sys_state, next_sys_state

    # If state has changed
    if (curr_sys_state != next_sys_state):
        
        # If anything is active, ready = 0
        if(
            ((next_sys_state >> status_flag.SAMPLING) & 1)      or \
            ((next_sys_state >> status_flag.PUMP) & 1)          or \
            ((next_sys_state >> status_flag.IMAGING) & 1)       or \
            ((next_sys_state >> status_flag.CALIBRATING) & 1)   or \
            ((next_sys_state >> status_flag.LEAK) & 1)
        ):
            set_sys_state(status_flag.READY, 0)

        # If not, ready = 1
        else:
            set_sys_state(status_flag.READY, 1)

        # If there is a leak, block other flags
        if((next_sys_state >> status_flag.LEAK) & 1):
            set_sys_state(status_flag.SAMPLING, 0)
            set_sys_state(status_flag.PUMP, 0)
            set_sys_state(status_flag.IMAGING, 0)
            set_sys_state(status_flag.CALIBRATING, 0)
        
        # Update state
        curr_sys_state = next_sys_state
        return True
    
    # If no state change
    else:
        return False
    

# --- Publish to the status flag topic ---
def publish_state(state):
    client.publish_message(
        t = client.con.topic.STATUS_FLAGS,
        m = state,
        r = True
    )
    

# --- Callback for state thread ---
def status_thread_cb():
    while True:
        if(check_sys_state()):
            publish_state(get_sys_state())
        else:
            time.sleep(0.001)
            

# --- Initialize state thread ---
def init_state_thread():
    status_thread = threading.Thread(target = status_thread_cb)
    status_thread.daemon = True
    status_thread.start()