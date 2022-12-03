import board
import focus_stepper as step
import rms_com as rms

i = 1
while(i == 1):
    sel = input('What is? [1=focus, 2=rms]\n')
    if(sel == '1'):
        step.adjustLens()
    elif (sel == '2'):
        rms.sendCMD()
    else:
        print('Invalid input')


if __name__ == '__main__':
    pass
