#
# camera.py
#
# Andreas Holleland
# 2023
#

#---------------------------- PACKAGES -----------------------------------------

import base64
import threading
import time
from picamera import PiCamera

import board
from adafruit_motorkit import MotorKit
from adafruit_motor import stepper

import state.sys_state as state
import mqtt.mqtt_client as client


#---------------------------- GLOBALS ------------------------------------------

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

camera = PiCamera()     # Camera object

image_path = '/home/pi/OtterUSV-PlanktonSystem/pis/data/image.jpg'

CAM_POS_MIN = 0         # Minimum allowed position (Ibidi slide side) 
CAM_POS_MAX = 10000     # Maximum allowed position (Stepper motor side)

prev_pos = 0            # Previous position of camera
curr_pos = 0            # Current position of camera
next_pos = 0            # Next position of camera

image_taken = False     # Flag indicating if an image has been taken


#---------------------------- FUNCTIONS ----------------------------------------

def capture_image():
    camera.capture(image_path)


def set_pos(new_pos):
    global prev_pos, curr_pos

    prev_pos = curr_pos
    curr_pos = new_pos


def image_thread_cb():
    global image_taken

    while True:
        if((state.get_sys_state() >> state.status_flag.IMAGING) & 1):
            print("Taking image")

            capture_image()

            with open(image_path, "rb") as image:
                img = image.read()

            message = img 
            base64_bytes = base64.b64encode(message)
            base64_message = base64_bytes.decode('ascii')

            client.pub_photo(base64_message)

            print("Image published")
                
            #image_taken = True
            state.set_sys_state(state.status_flag.IMAGING, 0)


def cal_thread_cb():
    while True:
        if((state.get_sys_state() >> state.status_flag.CALIBRATING) & 1):
            print("")


def init_cam_thread():
    cam_thread = threading.Thread(target = image_thread_cb)
    cam_thread.daemon = True
    cam_thread.start()


def init_cal_thread():
    cal_thread = threading.Thread(target = cal_thread_cb)
    cal_thread.daemon = True
    cal_thread.start()