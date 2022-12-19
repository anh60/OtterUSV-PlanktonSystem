#
# Andreas Hølleland
# 2022
#

import rms_com as rms

i = 1
while(i == 1):
    sel = input('WHAT IS? [1=FOCUS, 2=RMS, 3=CAMERA]\n')
    if(sel == '1'):
    elif (sel == '2'):
        rms.sendCMD()
    elif (sel == '3'):
    else:
        print('Invalid input')


if __name__ == '__main__':
    pass
