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

import state.sys_state as state


#---------------------------- GLOBALS ------------------------------------------

class sample_state(int, Enum):
    FILL = 0
    PUMP = 1
    IMAGE = 2
    UPLOAD = 3
    FLUSH = 4

curr_sample_state = 0
next_sample_state = 0

sample_num = 0
curr_sample = 0


#---------------------------- FUNCTIONS ----------------------------------------

def set_sample_num(n):
    global sample_num
    sample_num = n


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

    print("imaging sample", curr_sample, "\n")
    time.sleep(2)

    # Set next state
    if(curr_sample >= sample_num):
        next_sample_state = sample_state.UPLOAD
    else:
        next_sample_state = sample_state.PUMP


def upload():
    global next_sample_state

    print("uploading", sample_num, "images \n")
    time.sleep(2)

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
    state.set_sys_state(state.status_flag.SAMPLING, 0)

    print("Sampling finished, system ready \n")


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
