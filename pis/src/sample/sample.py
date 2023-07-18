# 
# sample.py
#
# Andreas Holleland
# 2023
#

#---------------------------- PACKAGES -----------------------------------------

import os
import threading
import time
from enum import Enum

import state.sys_state      as state
import cam.camera           as cam
import data.images          as imgs
import mqtt.mqtt_client     as client


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


#---------------------------- FUNCTIONS ----------------------------------------

def set_sample_num(n):
    global sample_num, sample_time, sample_dir

    sample_num = n

    sample_time = time.strftime('%Y%m%d%H%M%S')
    sample_dir = samples_path + sample_time

    lat = '63.5'
    lon = '10.3'
    pos_file = sample_dir + '/' + lat + ',' + lon + '.txt'

    os.mkdir(sample_dir)
    open(pos_file, 'a').close()




def fill():
    global next_sample_state

    print("filling reservoir \n")
    time.sleep(2)

    # Set next state
    next_sample_state = sample_state.PUMP


def pump():
    global next_sample_state, curr_sample

    curr_sample += 1
    print("collecting sample", curr_sample, "\n")
    time.sleep(2)

    # Set next state
    next_sample_state = sample_state.IMAGE


def image():
    global next_sample_state

    print("imaging sample", curr_sample, "\n"),

    image_time = time.strftime('%Y%m%d%H%M%S')
    image_path = sample_dir + '/' + image_time + '.jpg'
    cam.capture_image(image_path)

    # Set next state
    if(curr_sample >= sample_num):
        next_sample_state = sample_state.UPLOAD
    else:
        next_sample_state = sample_state.PUMP


def upload():
    global next_sample_state

    print("uploading", sample_num, "images \n")

    # Publish list of samples to MQTT broker
    imgs.send_samples()

    # Set next state
    next_sample_state = sample_state.FLUSH


def flush():
    global next_sample_state, curr_sample

    print("flushing system \n")
    time.sleep(2)

    # Reset thread
    curr_sample = 0
    next_sample_state = sample_state.FILL

    # Clear sampling flag
    state.set_sys_state(state.status_flag.READY, 0)

    print("Sampling finished, system ready \n")

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
        if((state.get_sys_state() >> state.status_flag.READY) & 1):
            sample_state_handler()
        else:
            time.sleep(0.1)


def init_sample_thread():
    sample_thread = threading.Thread(target = sample_thread_cb)
    sample_thread.daemon = True
    sample_thread.start()

