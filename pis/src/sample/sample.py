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
import rms.rms_com          as rms


#---------------------------- GLOBALS ------------------------------------------

# Sample states
class sample_state(int, Enum):
    FILL = 0
    PUMP = 1
    IMAGE = 2
    UPLOAD = 3
    FLUSH = 4

# State variables
curr_sample_state = 0
next_sample_state = 0

# Vehicle position
lat = 63.41729
lon = 10.40609

# 5V pump time
pump_init_time = 10
pump_time = 5

# Number of samples
sample_num = 0

# Current sample index
curr_sample = 0

# Storage location for images
samples_path = '/home/pi/OtterUSV-PlanktonSystem/pis/data/db_images/'

# Directory for current sample
sample_dir = 0

# Flags for sending RMS commands only once
fill_sent = False
flush_sent = False

# Flag when an error has occured
sample_error = False

# Timer for checking errors
rms_pump_timer = 0
rms_valve_timer = 0
rms_error_timeout = 5


#---------------------------- FUNCTIONS ----------------------------------------

# --- Set coordinates for next sample ---
def set_sample_pos(msg):
    global lat, lon
    try:
        coordinates = str(msg.decode("utf-8")).split(",")
        lat = round(float(coordinates[0]), 5)
        lon = round(float(coordinates[1]), 5)
    except:
        lat = 63.41729
        lon = 10.40609


# --- Configure the next sample ---
def sample_config(n):
    global sample_num, sample_dir, sample_error

    # Set number of samples/images to be taken
    sample_num = n

    try:
        # Create a directory to store the sample data
        sample_dir = imgs.create_sample_dir(str(lat), str(lon))
    except:
        # If it fails, set error flag
        sample_error = True


# --- Filling reservoir state ---
def fill():
    global next_sample_state, fill_sent, rms_pump_timer, sample_error

    if(fill_sent == False):
        # Send FILL command
        rms.send_fill()
        rms_pump_timer = time.perf_counter()
        fill_sent = True
    else:
        # Check timer for pump error
        if(((state.get_sys_state() >> state.state_flag.RMS_PUMP) & 1) == 0):
            if((time.perf_counter() - rms_pump_timer) >= rms_error_timeout):
                sample_error = True

    # If reservoir full
    if(((state.get_sys_state() >> state.state_flag.RMS_FULL) & 1) == 1):
        next_sample_state = sample_state.PUMP


# --- Pumping sample from reservoir state ---
def pump():
    global next_sample_state, curr_sample

    curr_sample += 1
    state.set_sys_state(state.state_flag.PUMP, 1)

    # If first sample
    if(curr_sample == 1):
        # Sleep for extended time
        time.sleep(pump_init_time)
    else:
        time.sleep(pump_time)
    state.set_sys_state(state.state_flag.PUMP, 0)

    # Set next state
    next_sample_state = sample_state.IMAGE


# --- Imaging a sample state ---
def image():
    global next_sample_state

    # Capture image
    # Here the imaging flag is just set so it can be observed during the
    # sample routine (request is ignored in the imaging thread when sampling).

    state.set_sys_state(state.state_flag.IMAGING, 1)
    image_path = imgs.create_image_path(sample_dir)
    cam.capture_image(image_path)
    state.set_sys_state(state.state_flag.IMAGING, 0)

    # If finished with all images
    if(curr_sample >= sample_num):
        next_sample_state = sample_state.UPLOAD

    # If not, go back to pump state
    else:
        next_sample_state = sample_state.PUMP


# --- Uploading/updating sample list state ---
def upload():
    global next_sample_state, sample_error
    
    # Publish list of samples to MQTT broker
    try:
        imgs.publish_samples()
    except:
        sample_error = True

    # Set next state
    next_sample_state = sample_state.FLUSH


# --- Flushing reservoir state ---
def flush():
    global next_sample_state, curr_sample
    global fill_sent, flush_sent
    global sample_error, rms_pump_timer, rms_valve_timer

    # Send FLUSH command
    if(flush_sent == False):
        rms.send_flush()
        rms_valve_timer = time.perf_counter()
        flush_sent = True
    else:
        # Check timer for valve error
        if(((state.get_sys_state() >> state.state_flag.RMS_VALVE) & 1) == 0):
            if((time.perf_counter() - rms_valve_timer) >= rms_error_timeout):
                sample_error = True

    # If reservoir empty
    if(((state.get_sys_state() >> state.state_flag.RMS_FULL) & 1) == 0):
        
        # Flush water from payload
        state.set_sys_state(state.state_flag.PUMP, 1)
        time.sleep(20)
        state.set_sys_state(state.state_flag.PUMP, 0)

        # Reset thread
        curr_sample = 0
        fill_sent = False
        flush_sent = False
        next_sample_state = sample_state.FILL

        # Clear sampling flag
        state.set_sys_state(state.state_flag.SAMPLING, 0)

        time.sleep(0.1)


# --- State machine ---
def sample_state_handler():
    global curr_sample_state, sample_error

    # Check for an error
    if(sample_error):
        sample_error = False
        state.set_sys_state(state.state_flag.SAMPLING, 0)
        time.sleep(0.1)

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


# --- Callback for sample thread ---
def sample_thread_cb():
    while True:
        if((state.get_sys_state() >> state.state_flag.SAMPLING) & 1):
            sample_state_handler()
        else:
            time.sleep(0.1)


# --- Initialize sample thread ---
def init_sample_thread():
    sample_thread = threading.Thread(target = sample_thread_cb)
    sample_thread.daemon = True
    sample_thread.start()

