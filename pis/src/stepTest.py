import time
import board
from adafruit_motorkit import MotorKit
from adafruit_motor import stepper

kit = MotorKit(i2c=board.I2C())

i = 0
while True:
    kit.stepper1.onestep(direction = stepper.BACKWARD)