#
# pump.py
#
# Andreas Hølleland
# 2023
#

import threading
import time
import board
from adafruit_motorkit import MotorKit

import state.sys_state as state

kit = MotorKit(i2c=board.I2C())


def pump_thread_cb():
    while True:
        if((state.get_sys_state() >> state.status_flag.PUMP) & 1):
            kit.motor3.throttle = -0.8
        else:
            kit.motor3.throttle = None
        time.sleep(0.01)
        


def init_pump_thread():
    pump_thread = threading.Thread(target = pump_thread_cb)
    pump_thread.daemon = True
    pump_thread.start()