import serial

port = 'COM4'
baud = 9600

C_PUMP = 0x01
C_FLUSH = 0x02
C_STOP = 0x03
C_STATUS = 0x04

cmds = [C_PUMP, C_FLUSH, C_STOP, C_STATUS]

i = 1
while(i == 1):
    
    ser = serial.Serial(port, baud, timeout = 1)

    cmd = int(input('ENTER COMMAND \n'))

    print(cmd, '\n')

    if(cmd in cmds):

        ser.write(cmd.to_bytes(1,'big'))
        rms_state = ser.read()
        print(rms_state, '\n')

    elif(cmd == 5):
        break

    else:
        print('INVALID COMMAND \n')

    ser.close()


