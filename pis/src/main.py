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
import sample.sample                as sample


#---------------------------- MAIN ---------------------------------------------

# Initialize threads
state.init_state_thread()       # System state handler thread
rms.init_rms_thread()           # RMS communication thread
client.init_mqtt_thread()       # MQTT client thread
pump.init_pump_thread()         # Pump thread
cam.init_cam_thread()           # Camera thread
sample.init_sample_thread()     # Sample routine thread

# Get state of RMS
rms.send_status_request()

print("Init complete, system ready")

# Loop main thread
while True:
    continue

if __name__ == '__main__':
    pass