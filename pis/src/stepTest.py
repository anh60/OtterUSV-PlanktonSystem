import time
import board
from adafruit_motorkit import MotorKit
from adafruit_motor import stepper

kit = MotorKit(i2c=board.I2C())

i = 0
for i in range(100):
    kit.stepper1.onestep()
    time.sleep(0.01)
    kit.stepper1.release()