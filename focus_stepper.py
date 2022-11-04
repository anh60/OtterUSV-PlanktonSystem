import board
from adafruit_motor import stepper
from time import sleep

def focus(mm: int):
    if mm < 0:
        direction = stepper.BACKWARD
        mm *= -1
    else:
        direction = stepper.FORWARD
    for _ in range(mm):
        kit.stepper1.onestep(direction=direction)
        #sleep(0.003)