# 
# sample.py
#
# Andreas Holleland
# 2023
#

#---------------------------- PACKAGES -----------------------------------------

import shutil
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

# Flag when an error has occured
sample_error = False

# Fill state flags
rms_fill_sent       = False
rms_pump_verified   = False
rms_pump_timer      = 0

# Flush state flags
rms_flush_sent      = False
rms_valve_verified  = False
rms_valve_timer     = 0

# RMS communication max wait time
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


# --- Fill reservoir state ---
def fill():
    global next_sample_state, sample_error
    global rms_fill_sent, rms_pump_verified, rms_pump_timer

    pump_flag = ((state.get_sys_state() >> state.state_flag.RMS_PUMP) & 1)

    # If FILL command has not been sent yet
    if(rms_fill_sent == False):

        # Send fill command and set timer/flag
        rms.send_fill()
        rms_pump_timer = time.perf_counter()
        rms_fill_sent = True

    # If sent, but pump flag has not been verified
    elif(rms_pump_verified == False):

        # If pump flag is 1, set the verified flag
        if(pump_flag == 1):
            rms_pump_verified = True

        # If pump flag is 0, check the timer
        else:
            elapsed_time = time.perf_counter() - rms_pump_timer

            # If timer exceeds timout value, raise error flag
            if(elapsed_time >= rms_error_timeout):
                sample_error = True
            else:
                pass

    # If reservoir full
    if(((state.get_sys_state() >> state.state_flag.RMS_FULL) & 1) == 1):
        next_sample_state = sample_state.PUMP


# --- Pump sample from reservoir state ---
def pump():
    global next_sample_state, curr_sample

    # Increment sample number
    curr_sample += 1

    # Activate pump
    state.set_sys_state(state.state_flag.PUMP, 1)

    # If first sample, pump for a longer period
    if(curr_sample == 1):
        time.sleep(pump_init_time)

    # If not, pump for a shorter period
    else:
        time.sleep(pump_time)

    # Deactivate pump
    state.set_sys_state(state.state_flag.PUMP, 0)

    # Set next state
    next_sample_state = sample_state.IMAGE


# --- Imaging state ---
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
    global rms_flush_sent, rms_valve_verified, rms_valve_timer
    global sample_error

    valve_flag = ((state.get_sys_state() >> state.state_flag.RMS_FULL) & 1)

    # Send FLUSH command
    if(rms_flush_sent == False):
        rms.send_flush()
        rms_valve_timer = time.perf_counter()
        rms_flush_sent = True

    # If sent, but valve flag has not been verified
    elif(rms_valve_verified == False):

        # If valve flag is 1, set the verified flag
        if(valve_flag == 1):
            rms_valve_verified = True

        # If valve flag is 0, check the timer
        else:
            elapsed_time = time.perf_counter() - rms_valve_verified

            # If timer exceeds timout value, raise error flag
            if(elapsed_time >= rms_error_timeout):
                sample_error = True
            else:
                pass

    # If reservoir empty
    if(((state.get_sys_state() >> state.state_flag.RMS_FULL) & 1) == 0):
        
        # Flush water from payload
        state.set_sys_state(state.state_flag.PUMP, 1)
        time.sleep(20)
        state.set_sys_state(state.state_flag.PUMP, 0)

        # Reset thread
        reset_sample_thread()


# --- Reset the sample routine variables ---
def reset_sample_thread():
        global curr_sample, sample_error
        global rms_fill_sent, rms_flush_sent
        global rms_pump_verified, rms_valve_verified
        global next_sample_state

        # Reset thread
        curr_sample = 0
        rms_fill_sent = False
        rms_flush_sent = False
        rms_pump_verified = False
        rms_valve_verified = False
        sample_error = False
        next_sample_state = sample_state.FILL

        # Clear sampling flag
        state.set_sys_state(state.state_flag.SAMPLING, 0)
        time.sleep(0.1)



# --- State machine ---
def sample_state_handler():
    global curr_sample_state, next_sample_state, sample_error
    global curr_sample, rms_fill_sent, rms_flush_sent
    global rms_pump_verified, rms_valve_verified
    global sample_dir

    # Check for an error
    if(sample_error == True):
        #imgs.remove_sample_dir(sample_dir)
        try:
            shutil.rmtree(dir)
        except:
            pass
        reset_sample_thread()

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

