# rms_com.py
#
# Andreas Holleland
# 2023
#

import serial
import threading

# Bottom USB3.0 (blue)
#port = '/dev/ttyUSB0'
port = 'COM4'
baud = 9600

C_PUMP      = 0x01
C_FLUSH     = 0x02
C_STOP      = 0x03
C_STATUS    = 0x04
cmds = [C_PUMP, C_FLUSH, C_STOP, C_STATUS]

rms_status = 0x00

ser = serial.Serial(port, baud, timeout=0)

def rx_thread_cb():
    while True:
        msg = ser.read()
        if msg:
            rms_status = msg
            print("RMS status: ", rms_status)

def tx_thread_cb():
    while True:
        cmd = int(input())
        if(cmd in cmds):
            ser.write(cmd.to_bytes(1,'big'))
        elif(cmd == 5):
            exit()
        else:
            print('INVALID COMMAND \n')
        
rx_thread = threading.Thread(target=rx_thread_cb)
tx_thread = threading.Thread(target=tx_thread_cb)

#rx_thread.daemon = True
#tx_thread.daemon = True

rx_thread.start()
tx_thread.start()