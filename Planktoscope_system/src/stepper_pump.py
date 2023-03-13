# stepper_pump.py
#
# Andreas Holleland
# 2023
#

import board
from adafruit_motorkit import MotorKit
from adafruit_motor import stepper

kit = MotorKit(i2c=board.I2C())

direction = stepper.BACKWARD
style = stepper.SINGLE

while True:
    kit.stepper1.onestep(direction=direction, style=style)