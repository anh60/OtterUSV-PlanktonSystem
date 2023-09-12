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

import state.sys_state  as state
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
min_pos = 500
max_pos = 40000

# Current and new(mqtt) camera position
curr_pos = 0
next_pos = 0

# Current and new(mqtt) LED brightness
curr_brightness = 0
next_brightness = 0


#---------------------------- FUNCTIONS ----------------------------------------

# --- Capture an image and store it in given path ---
def capture_image(path):
    kit.motor4.throttle = curr_brightness
    time.sleep(1)
    camera.capture(path)
    time.sleep(1)
    kit.motor4.throttle = None


# --- Publish an image from a given path ---
def publish_image(path):

    # Read image file from path
    with open(path, "rb") as image:
        img = image.read()

    # Convert to base64
    message = img 
    base64_bytes = base64.b64encode(message)
    base64_string = base64_bytes.decode('ascii')

    # Publish
    client.publish_message(
        t = client.con.topic.IMAGE,
        m = base64_string,
        r = True,
    )

# --- Get curr_position ---
def get_lens_position():
    return curr_pos


# --- Set next_position ---
def set_lens_position(new_pos):
    global curr_pos, next_pos
    next_pos = new_pos 


# --- Read position from file ---
def read_lens_position():
    f = open(posfile, 'r')
    pos = int(f.readline())
    f.close()
    return pos


# --- Write position to file ---
def write_lens_position(pos):
    f = open(posfile, 'w')
    f.write(str(pos))
    f.close()


# --- Publish lens position to MQTT broker ---
def publish_lens_position(pos):
    client.publish_message(
        t = client.con.topic.CAL_CURRPOS,
        m = pos,
        r = True
    )


# --- Move camera to new position ---
def move_camera(curr_pos, next_pos):
    # Get current position from file
    curr_pos = read_lens_position()

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

        # If backward, increment curr_pos
        else:
            curr_pos += 1
    
    # Write new position to file
    write_lens_position(curr_pos)

    # Publish new position
    publish_lens_position(curr_pos)

    # Release stepper so it doesn't draw current/overheat
    kit.stepper1.release()

    # Reset variables
    next_pos = curr_pos

    return curr_pos, next_pos


# --- Get curr_brightness ---
def get_led_brightness():
    return curr_brightness


# --- Set next_brightness ---
def set_led_brightness(new_brightness):
    global next_brightness

    # Convert from percentage to range [0,1] (values clamped later)
    try:
        next_brightness = new_brightness / 100

    # Ignore if illegal characters are received
    except:
        next_brightness = curr_brightness


# --- Read brightness from file ---
def read_led_brightness():
    f = open(ledFile, 'r')
    brightness = float(f.readline())
    f.close()
    return brightness


# --- Write brightness to file ---
def write_led_brightness(brightness):
    f = open(ledFile, 'w')
    f.write(str(brightness))
    f.close()


# --- Publish brightness to MQTT broker ---
def publish_led_brightness(brightness):

    # Convert to percentage
    brightness = brightness * 100

    # Publish
    client.publish_message(
        t = client.con.topic.CAL_CURRLED,
        m = brightness,
        r = True
    )


# --- Set LED brightness to value next value ---
def apply_brightness(curr_brightness, next_brightness):
    curr_brightness = next_brightness

    # Clamp values
    if(curr_brightness < 0):
        curr_brightness = 0
    elif(curr_brightness > 1):
        curr_brightness = 1

    # Write new brightness to file
    write_led_brightness(curr_brightness)

    # Publish new brightnes
    publish_led_brightness(curr_brightness)

    # Reset variables
    next_brightness = curr_brightness

    return curr_brightness, next_brightness


# --- Image thread callback ---
def image_thread_cb():
    while True:

        # If imaging flag = 1, execute thread
        if((state.get_sys_state() >> state.status_flag.IMAGING) & 1):
            
            # If sampling, the flag is just for observing over MQTT
            if((state.get_sys_state() >> state.status_flag.SAMPLING) & 1):
                pass

            # If not sampling, capture and publish image to 'image' topic
            else:
                capture_image(mqtt_image_path)
                publish_image(mqtt_image_path)
                
                state.set_sys_state(state.status_flag.IMAGING, 0)

            time.sleep(0.1)

        # If imaging flag = 0, sleep thread
        else:
            time.sleep(0.001)


# --- Calibration thread callback ---
def cal_thread_cb():
    global curr_pos, next_pos, curr_brightness, next_brightness

    while True:

        # If calibration flag = 1, execute thread
        if(((state.get_sys_state() >> state.status_flag.CALIBRATING) & 1) == 1):

            # If new position
            if(curr_pos != next_pos):
                
                # Move camera
                curr_pos, next_pos = move_camera(
                    curr_pos, next_pos
                )

            # If new brightness
            if(curr_brightness != next_brightness):
                
                # Apply new brightness
                curr_brightness, next_brightness = apply_brightness(
                    curr_brightness, next_brightness
                )

            state.set_sys_state(state.status_flag.CALIBRATING, 0)

            time.sleep(0.1)

        # If calibration flag = 0, sleep thread
        else:
            time.sleep(0.001)


# --- Initialize camera thread ---
def init_cam_thread():
    cam_thread = threading.Thread(target = image_thread_cb)
    cam_thread.daemon = True
    cam_thread.start()


# --- Initialize calibration thread ---
def init_cal_thread():
    global curr_pos, next_pos, curr_brightness, next_brightness

    # Release stepper so it doesn't draw current/overheat
    kit.stepper1.release()

    # Get current position
    curr_pos = read_lens_position()
    next_pos = curr_pos

    # Force LED off
    kit.motor4.throttle = None

    # Get current brightness
    curr_brightness = read_led_brightness()
    next_brightness = curr_brightness

    # Begin thread
    cal_thread = threading.Thread(target = cal_thread_cb)
    cal_thread.daemon = True
    cal_thread.start()