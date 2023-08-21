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

# Camera object
camera = PiCamera()

# Motor interface board
kit = MotorKit(i2c=board.I2C())

# Path to image for MQTT transfer over 'image' topic
mqtt_image_path = '/home/pi/OtterUSV-PlanktonSystem/pis/data/mqtt_image/image.jpg'

# File storing position data for microscope
posfile = '../data/position.txt'

# File storing current LED brightness
ledFile = '../data/brightness.txt'

# Min/max positions of camera lens (micrometers)
min_pos = 5000
max_pos = 40000

# Current and new(mqtt) camera position
curr_pos = 0
next_pos = 0

# Current and new(mqtt) LED brightness
curr_led = 0
next_led = 0

#---------------------------- FUNCTIONS ----------------------------------------

def capture_image(path):
    kit.motor4.throttle = curr_led
    time.sleep(1)
    camera.capture(path)
    time.sleep(1)
    kit.motor4.throttle = None


def set_pos(new_pos):
    global curr_pos, next_pos
    next_pos = new_pos 


def readLensPosition():
    f = open(posfile, 'r')
    pos = int(f.readline())
    f.close()
    return pos


def writeLensPosition(pos):
    f = open(posfile, 'w')
    f.write(str(pos))
    f.close()


def setLed(new_led):
    global next_led
    next_led = new_led / 100
    print('setting new led ', next_led)


def readLedBrightness():
    f = open(ledFile, 'r')
    brightness = f.readline()
    f.close()
    return brightness


def writeLedBrightness(brightness):
    f = open(ledFile, 'w')
    f.write(str(brightness))
    f.close()


def image_thread_cb():
    while True:
        if((state.get_sys_state() >> state.status_flag.IMAGING) & 1):

            capture_image(mqtt_image_path)

            with open(mqtt_image_path, "rb") as image:
                img = image.read()

            message = img 
            base64_bytes = base64.b64encode(message)
            base64_message = base64_bytes.decode('ascii')

            client.pub_photo(base64_message)
                
            state.set_sys_state(state.status_flag.IMAGING, 0)
            state.set_sys_state(state.status_flag.READY, 1)

            time.sleep(0.1)
        else:
            time.sleep(0.001)


def cal_thread_cb():
    global curr_pos, next_pos, curr_led, next_led

    while True:
        if(((state.get_sys_state() >> state.status_flag.CALIBRATING) & 1) == 1):
            if(curr_pos != next_pos):
                # Get current position from file
                curr_pos = readLensPosition()

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
                            break
                    else:
                        if(curr_pos == max_pos):
                            break
                    
                    # Move stepper motor
                    kit.stepper1.onestep(direction=direction)

                    # If moving camera forward, decrement curr_pos
                    if(direction == stepper.BACKWARD):
                        curr_pos -= 1

                    # If backward, increment
                    else:
                        curr_pos += 1
                
                writeLensPosition(curr_pos)
                client.pub_cam_pos(curr_pos)

                next_pos = curr_pos

            if(curr_led != next_led):
                curr_led = next_led

                if(curr_led < 0):
                    curr_led = 0
                elif(curr_led > 1):
                    curr_led = 1

                writeLedBrightness(curr_led)
                client.pub_led_brightness(int(curr_led * 100))

                next_led = curr_led


            state.set_sys_state(state.status_flag.CALIBRATING, 0)
            state.set_sys_state(state.status_flag.READY, 1)
            
            kit.stepper1.release()

            time.sleep(0.1)
        else:
            time.sleep(0.001)


def init_cam_thread():
    cam_thread = threading.Thread(target = image_thread_cb)
    cam_thread.daemon = True
    cam_thread.start()


def init_cal_thread():
    global curr_pos, next_pos, curr_led, next_led

    # Release stepper so it doesn't draw power
    kit.stepper1.release()

    # Get and publish current position
    curr_pos = readLensPosition()
    next_pos = curr_pos
    client.pub_cam_pos(curr_pos)

    # Make sure LED is turned off
    kit.motor4.throttle = None

    # Get and publish current LED brightness
    curr_led = readLedBrightness()
    next_led = curr_led
    client.pub_led_brightness(int(curr_led * 100))

    # Begin thread
    cal_thread = threading.Thread(target = cal_thread_cb)
    cal_thread.daemon = True
    cal_thread.start()