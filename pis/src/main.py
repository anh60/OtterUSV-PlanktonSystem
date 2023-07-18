# 
# main.py
#
# Andreas Holleland
# 2023
#

#---------------------------- PACKAGES -----------------------------------------

import state.sys_state              as state
import rms.rms_com                  as rms
import mqtt.mqtt_client             as client
import pump.pump                    as pump
import cam.camera                   as cam
import data.images                  as imgs
import sample.sample                as sample


#---------------------------- MAIN ---------------------------------------------

# Initialize threads
state.init_state_thread()       # System state handler thread
rms.init_rms_thread()           # RMS communication thread
client.init_mqtt_thread()       # MQTT client thread
pump.init_pump_thread()         # Pump thread
cam.init_cam_thread()           # Camera imaging thread
cam.init_cal_thread()           # Camera calibration thread
imgs.init_images_thread()       # Image file system thread
sample.init_sample_thread()     # Sample routine thread

# Send list of samples
imgs.send_samples()

# Get state of RMS
rms.send_status_request()

# Set ready flag
state.set_sys_state(state.status_flag.READY, 1)

# Loop main thread
while True:
    continue

if __name__ == '__main__':
    pass