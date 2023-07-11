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

# Camera 
camera = PiCamera()

# Stepper motor
kit = MotorKit(i2c=board.I2C())

# Path to image
image_path = '/home/pi/OtterUSV-PlanktonSystem/pis/data/image.jpg'

# Min/max positions of camera lens (distance from slide)
min_pos = 0
max_pos = 10000

curr_pos = 0
next_pos = 0


#---------------------------- FUNCTIONS ----------------------------------------

def capture_image():
    camera.capture(image_path)


def set_pos(new_pos):
    global curr_pos, next_pos
    next_pos = new_pos 


def image_thread_cb():
    while True:
        if((state.get_sys_state() >> state.status_flag.IMAGING) & 1):

            print("Taking image \n")

            capture_image()

            with open(image_path, "rb") as image:
                img = image.read()

            message = img 
            base64_bytes = base64.b64encode(message)
            base64_message = base64_bytes.decode('ascii')

            client.pub_photo(base64_message)

            print("Image published \n")
                
            state.set_sys_state(state.status_flag.IMAGING, 0)

            time.sleep(0.1)


def cal_thread_cb():
    global curr_pos, next_pos

    while True:
        if((state.get_sys_state() >> state.status_flag.CALIBRATING) & 1):
            print("Calibrating \n")

            # Set direction
            if(next_pos < curr_pos):
                # Camera forward
                direction = stepper.BACKWARD
                n_steps = curr_pos - next_pos
            else:
                # Camera backward
                direction = stepper.FORWARD
                n_steps = next_pos - curr_pos

            # Move camera
            for i in range(n_steps):

                # Check if min/max limit is reached
                if(direction == stepper.BACKWARD):
                    if(curr_pos == min_pos):
                        print("limit reached")
                        break
                else:
                    if(curr_pos == max_pos):
                        print("limit reached")
                        break
                
                # Move stepper motor
                kit.stepper1.onestep(direction=direction)

                # If moving camera forward, decrement curr_pos
                if(direction == stepper.BACKWARD):
                    curr_pos -= 1

                # If backward, increment
                else:
                    curr_pos += 1

                time.sleep(0.01)

            state.set_sys_state(state.status_flag.CALIBRATING, 0)
            client.pub_cam_pos(curr_pos)
            next_pos = curr_pos

            print("moved to new position", curr_pos)

            time.sleep(0.1)






def init_cam_thread():
    cam_thread = threading.Thread(target = image_thread_cb)
    cam_thread.daemon = True
    cam_thread.start()


def init_cal_thread():
    cal_thread = threading.Thread(target = cal_thread_cb)
    cal_thread.daemon = True
    cal_thread.start()