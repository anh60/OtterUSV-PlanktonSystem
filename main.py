import board
from adafruit_motorkit import MotorKit
from adafruit_motor import stepper
from time import sleep

kit = MotorKit(i2c=board.I2C())

# Position of lens relative to the IBIDI slide (millimeters)
LENS_POS = 0   
# Minimum allowed position (Ibidi slide side)   
LENS_POS_MIN = 0
# Maximum allowed position (Stepper motor side)
LENS_POS_MAX = 10000

PUMP_RATE = 0.22    # ml/sec

# Read and set lens position from 'position.txt'
def readLensPosition():
    f = open('position.txt', 'r')
    LENS_POS = f.readline()
    f.close()
    print("Lens position read", LENS_POS)

# Write new lens position to 'position.txt'
def writeLensPosition():
    f = open('position.txt', 'w')
    f.write(str(LENS_POS))
    f.close()
    print("Lens position stored")

# Adjust lens position with stepper motor
def focus(mm: int, LENS_POS):
    # Set direction
    if mm < 0:
        direction = stepper.BACKWARD
        mm *= -1
    else:
        direction = stepper.FORWARD

    # Move lens
    for i in range(mm):
        # Checking if lens is at min or max positions.
        print("Checking min/max pos")
        if mm < 0:
            if LENS_POS == LENS_POS_MIN:
                print("Minimum limit reached")
                break
        else:
            if LENS_POS == LENS_POS_MAX:
                print("Maximum limit reached")
                break
        
        # Move stepper motor
        print("moving stepper")
        kit.stepper1.onestep(direction=direction)

        if mm < 0:
            LENS_POS = LENS_POS + 1
        else:
            LENS_POS = LENS_POS - 1
        
        #print("Lens position: ", LENS_POS)
        #sleep(0.003)

readLensPosition()
focus(1000, LENS_POS)
writeLensPosition()


if __name__ == '__main__':
    pass
