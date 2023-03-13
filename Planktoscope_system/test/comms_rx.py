import serial

i = 1
while(i == 1):

    ser = serial.Serial(port     = 'COM4', 
                        baudrate = 9600, 
                        timeout  = None, 
                        xonxoff  = False, 
                        rtscts   = False,
                        dsrdtr   = False
                        )
    
    msg = ser.read()
    print(msg)

    ser.close()

