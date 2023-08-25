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