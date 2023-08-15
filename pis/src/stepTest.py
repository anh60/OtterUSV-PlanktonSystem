import time
import board
from adafruit_motorkit import MotorKit
from adafruit_motor import stepper

kit = MotorKit(i2c=board.I2C())

while True:
    kit.stepper1.onestep()
    time.sleep(0.001)
