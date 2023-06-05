# 
# rms_com.py
#
# Andreas Holleland
# 2023
#

#---------------------------- PACKAGES -----------------------------------------

import serial
import threading
import STATUS.status as state


#---------------------------- GLOBALS ------------------------------------------

# Bottom USB3.0 (blue)
port = '/dev/ttyUSB0'
#port = 'COM4'
baud = 9600

C_PUMP      = 0x01
C_FLUSH     = 0x02
C_STOP      = 0x03
C_STATUS    = 0x04

rms_state = 0

ser = serial.Serial(port, baud, timeout=0)


#---------------------------- FUNCTIONS ----------------------------------------

def init_comms():
    rx_thread = threading.Thread(target = rx_thread_cb)
    rx_thread.daemon = True
    rx_thread.start()


def rx_thread_cb():
    global rms_state
    while True:
        msg = ser.read()
        if msg:
            rms_state = int.from_bytes(msg, 'big')
            set_rms_flags(rms_state)


def set_rms_flags(s):
    state.set_sys_state(state.status_flag.RMS_PUMP,  ((s >> 0) & 1))
    state.set_sys_state(state.status_flag.RMS_VALVE, ((s >> 1) & 1))
    state.set_sys_state(state.status_flag.RMS_LEAK,  ((s >> 2) & 1))
    state.set_sys_state(state.status_flag.RMS_FULL,  ((s >> 3) & 1))


def send_pump():
    ser.write(C_PUMP.to_bytes(1, 'big'))


def send_flush():
    ser.write(C_FLUSH.to_bytes(1, 'big'))


def send_stop():
    ser.write(C_STOP.to_bytes(1, 'big'))


def send_status_request():
    ser.write(C_STATUS.to_bytes(1, 'big'))
    