# 
# sample.py
#
# Andreas Holleland
# 2023
#

#---------------------------- PACKAGES -----------------------------------------

import threading
import time
from enum import Enum

import state.sys_state      as state
import cam.camera           as cam
import data.images          as imgs
import mqtt.mqtt_client     as client
import rms.rms_com          as rms


#---------------------------- GLOBALS ------------------------------------------

class sample_state(int, Enum):
    FILL = 0
    PUMP = 1
    IMAGE = 2
    UPLOAD = 3
    FLUSH = 4

curr_sample_state = 0
next_sample_state = 0

# Number of samples
sample_num = 0

# Current sample index
curr_sample = 0

# Storage location for images
samples_path = '/home/pi/OtterUSV-PlanktonSystem/pis/data/db_images/'

# Directory for current sample
sample_dir = 0,

# Flags for sending RMS commands only once
fill_sent = False
flush_sent = False


#---------------------------- FUNCTIONS ----------------------------------------

def set_sample_num(n):
    global sample_num, sample_dir

    sample_num = n
    sample_dir = imgs.create_sample_dir()
    cam.set_sample_dir(sample_dir)


# Filling reservoir
def fill():
    global next_sample_state, fill_sent

    # Send FILL command
    if(fill_sent == False):
        rms.send_fill()
        fill_sent = True

    # If reservoir full
    if(((state.get_sys_state() >> state.status_flag.RMS_FULL) & 1) == 1):
        next_sample_state = sample_state.PUMP


# Pumping sample from reservoir
def pump():
    global next_sample_state, curr_sample

    curr_sample += 1
    state.set_sys_state(state.status_flag.PUMP, 1)
    if(curr_sample == 1):
        time.sleep(10)
    else:
        time.sleep(5)
    state.set_sys_state(state.status_flag.PUMP, 0)

    # Set next state
    next_sample_state = sample_state.IMAGE


# Imaging a sample
def image():
    global next_sample_state

    # Capture image
    state.set_sys_state(state.status_flag.IMAGING, 1)

    # Set next state
    if(curr_sample >= sample_num):
        next_sample_state = sample_state.UPLOAD
    else:
        next_sample_state = sample_state.PUMP


# Uploading/updating sample list
def upload():
    global next_sample_state

    # If imaging in progress
    if((state.get_sys_state() >> state.status_flag.IMAGING) & 1):
        pass
    
    # If imaging done
    else:
        # Publish list of samples to MQTT broker
        imgs.publishSamples()

        # Set next state
        next_sample_state = sample_state.FLUSH


# Flushing reservoir
def flush():
    global next_sample_state, curr_sample, fill_sent, flush_sent

    # Send FLUSH command
    if(flush_sent == False):
        rms.send_flush()
        flush_sent = True

    # If reservoir empty
    if(((state.get_sys_state() >> state.status_flag.RMS_FULL) & 1) == 0):
        
        # Remove water from 5v
        state.set_sys_state(state.status_flag.PUMP, 1)
        time.sleep(20)
        state.set_sys_state(state.status_flag.PUMP, 0)

        # Reset thread
        curr_sample = 0
        fill_sent = False
        flush_sent = False
        next_sample_state = sample_state.FILL

        # Clear sampling flag
        state.set_sys_state(state.status_flag.SAMPLING, 0)

        time.sleep(0.1)


def sample_state_handler():
    global curr_sample_state

    # Check for a state transition, and update state
    if(next_sample_state != curr_sample_state):
        curr_sample_state = next_sample_state

    # FILL state
    if(curr_sample_state == sample_state.FILL):
        fill()

    # PUMP state
    if(curr_sample_state == sample_state.PUMP):
        pump()

    # IMAGE state
    if(curr_sample_state == sample_state.IMAGE):
        image()
    
    # UPLOAD state
    if(curr_sample_state == sample_state.UPLOAD):
        upload()

    # FLUSH state
    if(curr_sample_state == sample_state.FLUSH):
        flush()


def sample_thread_cb():
    while True:
        if((state.get_sys_state() >> state.status_flag.SAMPLING) & 1):
            sample_state_handler()
        else:
            time.sleep(0.1)


def init_sample_thread():
    sample_thread = threading.Thread(target = sample_thread_cb)
    sample_thread.daemon = True
    sample_thread.start()

