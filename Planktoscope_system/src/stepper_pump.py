# stepper_pump.py
#
# Andreas Holleland
# 2023
#

import time
import board
from adafruit_motorkit import MotorKit

kit = MotorKit(i2c=board.I2C())

while True:
    kit.stepper1.onestep(direction=stepper.FORWARD, style=DOUBLE)