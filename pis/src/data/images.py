# 
# images.py
#
# Andreas Holleland
# 2023
#

#---------------------------- PACKAGES -----------------------------------------

from enum import Enum
import threading
import os

import mqtt.mqtt_client as client


#---------------------------- GLOBALS ------------------------------------------

samples_path = '/home/pi/OtterUSV-PlanktonSystem/pis/data/db_images'

class column(str, Enum):
    ST      = 'sample_time'
    LAT     = 'latitude'
    LON     = 'longitude'
    IT      = 'image_times'


#---------------------------- FUNCTIONS ----------------------------------------

# Get date/time of all samples taken (sample_times)
def get_sample_times():
    sample_names = [f.name for f in os.scandir(samples_path) if f.is_dir()]
    
    for name in sample_names:
        print(name)

    print('\n')
        
            

# Get date/time of images (sample_times[i] -> image_times)
def get_image_times(sample_time):
    print()


# Get image (sample_times[i] -> image_times[j] -> image)
def get_image(sample_time, image_time):
    print()


# Images thread callback function
def images_thread_cb():
    while True:
        print()


# Initialize images thread
def init_images_thread():
    sample_names = [f.name for f in os.scandir(samples_path) if f.is_dir()]
    client.pub_sample_times(sample_names)
    #images_thread = threading.Thread(target = images_thread_cb)
    #images_thread.daemon = True
    #images_thread.start()