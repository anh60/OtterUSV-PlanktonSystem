#
# Andreas Hølleland
# 2022
#

import serial

# Bottom USB3.0 (blue)
port = '/dev/ttyUSB0'

# CONTROL SIGNALS
CMD1 = '1'      # Fill reservoir
CMD2 = '2'      # Stop pump
CMD3 = '3'      # Flush reservoir
CMD4 = '4'      # Close valve
CMD5 = '5'      # Request status
CMD6 = '6'      # Force Idle state (communication problem)

commands = [CMD1, CMD2, CMD3, CMD4, CMD5, CMD6]

# STATUS SIGNALS
STA1 = '1'      # Reservoir idle
STA2 = '2'      # Reservoir full
STA3 = '3'      # Pumping started
STA4 = '4'      # Flushing started
STA5 = '5'      # Internal leak detected

# ERROR SIGNALS
ERR1 = '6';     # Pump already on
ERR2 = '7';     # Pump already off
ERR3 = '8';     # Valve already open
ERR4 = '9';     # Valve already closed

status = [STA1, STA2, STA3, STA4, STA5, ERR1, ERR2, ERR3, ERR4]

# Decode status signals to corresponding messages
def decodeSTA(sta):
    msg = '0'
    if   (sta == STA1):
        msg = 'IDLE'
    elif (sta == STA2):
        msg = 'FULL'
    elif (sta == STA3):
        msg = 'PUMPING'
    elif (sta == STA4):
        msg = 'FLUSHING'
    elif (sta == STA5):
        msg = 'LEAK'
    elif (sta == ERR1):
        msg = 'PUMP ALREADY ON'
    elif (sta == ERR2):
        msg = 'PUMP ALREADY OFF'
    elif (sta == ERR3):
        msg = 'VALVE ALREADY OPEN'
    elif (sta == ERR4):
        msg = 'VALVE ALDREADY CLOSED'
    return msg

# Transmit control signal and recieve status
def sendCMD():
    i = 1
    while(i == 1):
        ser = serial.Serial(port, 9600, timeout = 1)
        cmd = input('ENTER COMMAND \n')
        if(cmd in commands):
            ser.write(cmd.encode())
            sta = ser.read()
            if(sta.decode() in status):
                msg = decodeSTA(sta.decode())
                print(msg,'\n')
            else:
                ser.write(CMD6.encode())        # Force RMS to idle state
                print('RMS NOT RESPONDING')
        elif(cmd == 'x'):
            break
        else:
            print('IVALID COMMAND \n')
        ser.close()

