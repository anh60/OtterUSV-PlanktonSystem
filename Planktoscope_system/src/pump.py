#
# Andreas Hølleland
# 2022
#

import time
import board
from adafruit_motorkit import MotorKit

kit = MotorKit(i2c=board.I2C()) 

# Pump rate = 100mL/min at throttle=1.0
#           = 1.6mL/sec at throttle=1.0

PUMP_RATE = 0.22    # mL/sec     

def pump(ml: int):
    if ml < 0:
        kit.motor3.throttle = -0.5
        ml *= -1
    else:
        kit.motor3.throttle = 0.5
    time.sleep(ml / PUMP_RATE)
    kit.motor3.throttle = None

kit.motor3.throttle = 1.0