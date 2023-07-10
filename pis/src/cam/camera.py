#
# Andreas Hølleland
# 2022
#

import threading
from picamera import PiCamera

import board
from adafruit_motorkit import MotorKit
from adafruit_motor import stepper

import state.sys_state as state

camera = PiCamera()

# Ideas:
#   -   Manual calibration? Using buttons on the app,
#       as this only has to be done once (probably)
#       First set minimum (ibidi slide side), then navigate and set maximum
#       Maybe move in increments at every button press? e.g 10 or 100 steps
# 
#   -   Store min/max in file
#       (get at startup, store after calibration)
#
#   -   Store current position in file (get at startup and store after moving)
#       Perhaps store this in persistent database?
#       In case retained mqtt message isn't good/reliable enough
#       
#       If I rely on local storage, maybe publish min/max/current
#       to broker on startup/changes?
#
# Todo:
#   - Test to see how far back I can go with microscope
#   

CAM_POS_MIN = 0         # Minimum allowed position (Ibidi slide side) 
CAM_POS_MAX = 10000     # Maximum allowed position (Stepper motor side)

prev_pos = 0
curr_pos = 0

def capture_image():
    path = '/home/pi/OtterUSV-PlanktonSystem/Planktoscope_system/data/image.jpg'
    camera.capture(path)

def set_pos(pos):
    curr_pos = pos

def cam_thread_cb():
    if((state.get_sys_state() >> state.status_flag.CALIBRATING) & 1):
        print("")

def init_cam_thread():
    cam_thread = threading.Thread(target = cam_thread_cb)
    cam_thread.daemon = True
    cam_thread.start()