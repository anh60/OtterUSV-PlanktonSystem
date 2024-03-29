# 
# main.py
#
# Andreas Holleland
# 2023
#

#---------------------------- PACKAGES -----------------------------------------

import time

import state.sys_state              as state
import rms.rms_com                  as rms
import mqtt.mqtt_client             as client
import pump.pump                    as pump
import cam.camera                   as cam
import data.images                  as imgs
import sensor.sensor                as sensor
import sample.sample                as sample


#---------------------------- MAIN ---------------------------------------------

# Initialize threads
state.init_state_thread()       # System state handler thread
client.init_mqtt_thread()       # MQTT client thread
rms.init_rms_thread()           # RMS communication thread
pump.init_pump_thread()         # Pump thread
cam.init_cam_thread()           # Camera imaging thread
cam.init_cal_thread()           # Camera calibration thread
sensor.init_leak_thread()       # Leak detection thread
sample.init_sample_thread()     # Sample routine thread
imgs.init_images_thread()       # Image file system thread


# Get state of RMS
rms.send_status_request()

# Publish system state
state.publish_state(state.get_sys_state())

# Publish lens position
cam.publish_lens_position(cam.get_lens_position())

# Publish LED brightness
cam.publish_led_brightness(cam.get_led_brightness())

# Publish list of samples
imgs.publish_samples()

# Set ready flag
state.set_sys_state(state.state_flag.READY, 1)

# Loop main thread
while True:
    time.sleep(1)

if __name__ == '__main__':
    pass