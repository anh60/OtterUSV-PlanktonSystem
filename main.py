import board
from adafruit_motorkit import MotorKit
from adafruit_motor import stepper
from time import sleep

kit = MotorKit(i2c=board.I2C())
 
# Minimum allowed position (Ibidi slide side)   
CAM_POS_MIN = 0
# Maximum allowed position (Stepper motor side)
CAM_POS_MAX = 10000

PUMP_RATE = 0.22    # ml/sec

# Read and set lens position from 'position.txt'
def readLensPosition():
    f = open('position.txt', 'r')
    POS = int(f.readline())
    f.close()
    return POS

# Write new lens position to 'position.txt'
def writeLensPosition(POS):
    f = open('position.txt', 'w')
    f.write(str(POS))
    f.close()

# Adjust lens position with stepper motor
def focus(steps, POS):
    # Set direction
    if steps < 0:
        direction = stepper.BACKWARD # CAMERA FORWARD
        steps *= -1
    else:
        direction = stepper.FORWARD # CAMERA BACKWARD

    # Move lens
    for i in range(steps):
        # Checking if lens is at min or max positions.
        if direction == stepper.BACKWARD:
            if POS == CAM_POS_MIN:
                print("Minimum limit reached")
                break
        elif direction == stepper.FORWARD:
            if POS == CAM_POS_MAX:
                print("Maximum limit reached")
                break
        
        # Move stepper motor
        kit.stepper1.onestep(direction=direction)

        if direction == stepper.BACKWARD:   # CAMERA FORWARD
            POS -= 1
        elif direction == stepper.FORWARD:  # CAMERA BACKWARD
            POS += 1
    
    return POS

LENS_POS = readLensPosition()
LENS_POS = focus(1000, LENS_POS)
writeLensPosition(LENS_POS)

if __name__ == '__main__':
    pass
