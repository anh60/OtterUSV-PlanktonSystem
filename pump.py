import board
from adafruit_motorkit import MotorKit
kit = MotorKit(i2c=board.I2C())

def pump(ml: int):
    if ml < 0:
        kit.motor3.throttle = -0.5
        ml *= -1
    else:
        kit.motor3.throttle = 0.5
    sleep(ml / PUMP_RATE)
    kit.motor3.throttle = None