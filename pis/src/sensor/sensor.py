# 
# sensor.py
#
# Andreas Holleland
# 2023
#

#---------------------------- PACKAGES -----------------------------------------

import RPi.GPIO as GPIO
import time
import threading
import state.sys_state as state


#---------------------------- GLOBALS ------------------------------------------

gpio_num = 17

#---------------------------- FUNCTIONS ----------------------------------------

def check_sensor(val):
    time.sleep(1)
    if(GPIO.input(gpio_num) == val):
        state.set_sys_state(state.status_flag.LEAK, val)


def leak_thread_cb():
    # If sensor output is HIGH
    if(GPIO.input(gpio_num)):

        print('1')

        # If in leak state, do nothing
        if((state.get_sys_state() >> state.status_flag.LEAK) & 1):
            pass

        # If not in leak state, double check sensor value
        else:
            check_sensor(1)

    # If sensor output is LOW
    else:

        print(0)

        # If in leak state, double check sensor value
        if((state.get_sys_state() >> state.status_flag.LEAK) & 1):
            check_sensor(0)

        # If not in leak state, do nothing
        else:
            pass

    time.sleep(0.1)


def init_leak_thread():
    GPIO.setmode(GPIO.BCM)
    GPIO.setup(gpio_num, GPIO.IN)

    leak_thread = threading.Thread(target = leak_thread_cb)
    leak_thread.daemon = True
    leak_thread.start()