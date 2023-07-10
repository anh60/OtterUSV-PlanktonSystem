# 
# main.py
#
# Andreas Holleland
# 2023
#

#---------------------------- PACKAGES -----------------------------------------

import state.sys_state              as state
import rms.rms_com                  as rms
import mqtt_client.mqtt_client      as client
import pump.pump                    as pump
import sample.sample                as sample


#---------------------------- MAIN ---------------------------------------------

# Initialize threads
state.init_state_thread()       # System state handler thread
rms.init_rms_thread()           # RMS communication thread
client.init_mqtt_thread()       # MQTT client thread
pump.init_pump_thread()         # Pump thread
sample.init_sample_thread()     # Sample routine thread

# Get state of RMS
rms.send_status_request()

# Loop main thread
while True:
    continue

if __name__ == '__main__':
    pass