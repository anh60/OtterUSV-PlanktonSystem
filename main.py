import board
from adafruit_motorkit import MotorKit
from adafruit_motor import stepper
from time import sleep

PUMP_RATE = 0.22    # ml/sec

kit = MotorKit(i2c=board.I2C())


def pump(ml: int):
    if ml < 0:
        kit.motor3.throttle = -0.5
        ml *= -1
    else:
        kit.motor3.throttle = 0.5
    sleep(ml / PUMP_RATE)
    kit.motor3.throttle = None


def focus(mm: int):
    if mm < 0:
        direction = stepper.BACKWARD
        mm *= -1
    else:
        direction = stepper.FORWARD
    for _ in range(mm):
        kit.stepper1.onestep(direction=direction)
        #sleep(0.003)


if __name__ == '__main__':
    pass
