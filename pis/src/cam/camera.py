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

# Camera 
camera = PiCamera()

# Path to image for MQTT transfer
mqtt_image_path = '/home/pi/OtterUSV-PlanktonSystem/pis/data/mqtt_image/image.jpg'

# Motor interface board
kit = MotorKit(i2c=board.I2C())

# Min/max positions of camera lens (distance from slide)
min_pos = 0
max_pos = 10000

# Current position and new position(received over MQTT)
curr_pos = 0
next_pos = 0


#---------------------------- FUNCTIONS ----------------------------------------

def capture_image(path):
    camera.capture(path)


def set_pos(new_pos):
    global curr_pos, next_pos
    next_pos = new_pos 


def image_thread_cb():
    while True:
        if((state.get_sys_state() >> state.status_flag.IMAGING) & 1):

            print("Taking image \n")

            capture_image(mqtt_image_path)

            with open(mqtt_image_path, "rb") as image:
                img = image.read()

            message = img 
            base64_bytes = base64.b64encode(message)
            base64_message = base64_bytes.decode('ascii')

            client.pub_photo(base64_message)

            print("Image published \n")
                
            state.set_sys_state(state.status_flag.IMAGING, 0)
            state.set_sys_state(state.status_flag.READY, 1)

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
                kit.stepper1.onestep(direction=direction, style=stepper.DOUBLE)

                # If moving camera forward, decrement curr_pos
                if(direction == stepper.BACKWARD):
                    curr_pos -= 1

                # If backward, increment
                else:
                    curr_pos += 1

                time.sleep(0.01)

            state.set_sys_state(state.status_flag.CALIBRATING, 0)
            state.set_sys_state(state.status_flag.READY, 1)
            client.pub_cam_pos(curr_pos)
            next_pos = curr_pos

            print("moved to new position", curr_pos)
            
            kit.stepper1.release()

            time.sleep(0.1)


def init_cam_thread():
    cam_thread = threading.Thread(target = image_thread_cb)
    cam_thread.daemon = True
    cam_thread.start()


def init_cal_thread():
    cal_thread = threading.Thread(target = cal_thread_cb)
    cal_thread.daemon = True
    cal_thread.start()