import board
import focus_stepper as step
import rms_com as rms

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

def getSteps():
    steps = input('Enter amount of steps\n')
    return int(steps)


sel = input('What is? [1 = focus] [2 = reservoir]')
if(sel == '1'):
    LENS_POS = readLensPosition()
    print("Current position: ", LENS_POS)
    LENS_POS = step.focus(getSteps(), LENS_POS)
    print("New position: ", LENS_POS)
    writeLensPosition(LENS_POS)
elif (sel == '2'):
    rms.sendCMD()
else:
    print('Invalid input')
    

if __name__ == '__main__':
    pass
