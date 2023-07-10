# 
# sample.py
#
# Andreas Holleland
# 2023
#

import threading
import time
from enum import Enum

import state.sys_state as state

class sample_state(int, Enum):
    FILL = 0
    PUMP = 1
    IMAGE = 2
    UPLOAD = 3
    FLUSH = 4

curr_sample_state = 0
next_sample_state = 0

sample_num = 4
curr_sample = 0


def set_sample_num(n):
    global sample_num
    sample_num = n


def sample_state_handler():
    global curr_sample_state, next_sample_state, curr_sample

    # Check for a state transition
    if(next_sample_state != curr_sample_state):
        curr_sample_state = next_sample_state
        print("")

    # FILL state
    if(curr_sample_state == sample_state.FILL):
        print("filling reservoir")
        time.sleep(2)

        # Set next state
        next_sample_state = sample_state.PUMP

    # PUMP state
    if(curr_sample_state == sample_state.PUMP):
        curr_sample = curr_sample + 1
        print("collecting sample ", curr_sample)
        time.sleep(2)

        # Set next state
        next_sample_state = sample_state.IMAGE

    # IMAGE state
    if(curr_sample_state == sample_state.IMAGE):
        print("imaging sample ", curr_sample)
        time.sleep(2)

        # Set next state
        if(curr_sample == sample_num):
            next_sample_state = sample_state.UPLOAD
        else:
            next_sample_state = sample_state.IMAGE
    
    # UPLOAD state
    if(curr_sample_state == sample_state.UPLOAD):
        print("uploading ", sample_num, " images")
        time.sleep(2)

        # Set next state
        next_sample_state = sample_state.FLUSH

    # FLUSH state
    if(curr_sample_state == sample_state.FLUSH):
        print("flushing system")
        time.sleep(2)
        state.set_sys_state(state.status_flag.SAMPLING, 0)
        print("Sampling finished, system ready")



def sample_thread_cb():
    if((state.get_sys_state() >> state.status_flag.SAMPLING) & 1):
        sample_state_handler()
    else:
        time.sleep(0.1)


def init_sample_thread():
    sample_thread = threading.Thread(target = sample_thread_cb)
    sample_thread.daemon = True
    sample_thread.start()
