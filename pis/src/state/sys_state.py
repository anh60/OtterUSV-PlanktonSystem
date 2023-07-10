# 
# sys_state.py
#
# Andreas Holleland
# 2023
#

#---------------------------- PACKAGES -----------------------------------------

from enum import Enum
import threading

import mqtt_client.mqtt_client as client


#---------------------------- GLOBALS ------------------------------------------

curr_sys_state = 0
next_sys_state = 0

class status_flag(int, Enum):
    
    # RMS
    RMS_PUMP        = 0
    RMS_VALVE       = 1
    RMS_FULL        = 2
    RMS_LEAK        = 3

    # PIS
    SAMPLING        = 4
    PUMP            = 5
    CALIBRATING     = 6
    LEAK            = 7 


#---------------------------- FUNCTIONS ----------------------------------------


def get_sys_state():
    global curr_sys_state, next_sys_state
    return curr_sys_state


def set_sys_state(flag, val):
    global curr_sys_state, next_sys_state
    if(val == 1):
        next_sys_state |= (1 << flag)
    else:
        next_sys_state &= (~(1 << flag))


def update_sys_state():
    global curr_sys_state, next_sys_state
    if (curr_sys_state != next_sys_state):
        curr_sys_state = next_sys_state
        return True
    else:
        return False
    

def status_thread_cb():
    while True:
        if(update_sys_state()):
            client.pub_status()
            

def init_state_thread():
    status_thread = threading.Thread(target = status_thread_cb)
    status_thread.daemon = True
    status_thread.start()