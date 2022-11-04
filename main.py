import board
from adafruit_motorkit import MotorKit
from adafruit_motor import stepper
from time import sleep

kit = MotorKit(i2c=board.I2C())

LENS_POS = 100        # Position of lens in millimeters relative to the IBIDI slide
PUMP_RATE = 0.22    # ml/sec

def getLensPosition():
    f = open('position.txt', 'r')
    LENS_POS = f.readline()
    f.close()
    print("File read", LENS_POS)

def focus(mm: int):
    if mm < 0:
        direction = stepper.BACKWARD
        mm *= -1
    else:
        direction = stepper.FORWARD
    for _ in range(mm):
        kit.stepper1.onestep(direction=direction)
        #sleep(0.003)

print(LENS_POS)
getLensPosition()

if __name__ == '__main__':
    pass
