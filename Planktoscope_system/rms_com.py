import serial

port = '/dev/ttyUSB0'

# CONTROL SIGNALS
CMD1 = '1'      # Fill reservoir
CMD2 = '2'      # Stop pump
CMD3 = '3'      # Flush reservoir
CMD4 = '4'      # Close valve
CMD5 = '5'      # Request status

commands = [CMD1, CMD2, CMD3, CMD4, CMD5]

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

def decodeSTA(sta):
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

def sendCMD():
    ser = serial.Serial(port, 9600)
    cmd = input('ENTER COMMAND \n')
    cmd = cmd.encode() 

    for i in commands:
        if (i.encode() == cmd):
            ser.write(cmd)
            sta = ser.read()
            msg = decodeSTA(sta.decode())
            print(msg,'\n')
            break
        else:
            print('INVALID COMMAND \n')
            break
    ser.close()

i = 1
while(i == 1):
    sendCMD()

