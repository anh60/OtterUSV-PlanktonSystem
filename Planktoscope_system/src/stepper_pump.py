# stepper_pump.py
#
# Andreas Holleland
# 2023
#

import time
import board
from adafruit_motorkit import MotorKit
from adafruit_motor import stepper

kit = MotorKit(i2c=board.I2C())

d = stepper.FORWARD
s = stepper.DOUBLE

while True:
    kit.stepper1.onestep(direction=d, style=s)
    time.sleep(0.01)