import serial
ser = serial.Serial('/dev/ttyUSB0',9600)

command = input('Enter cmmand \n')
ser.write(command)