import serial

port = '/dev/ttyUSB0'

i = 1
while(i == 1):
    ser = serial.Serial(port, 9600)
    command = input('Enter command \n')
    ser.write(command.encode())
    status = ser.read()
    print(status.encode())
    ser.close()

