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


#---------------------------- GLOBALS ------------------------------------------

samples_path = '/home/pi/OtterUSV-PlanktonSystem/pis/data/db_images'
sample_names = []

class column(str, Enum):
    ST      = 'sample_time'
    LAT     = 'latitude'
    LON     = 'longitude'
    IT      = 'image_times'


#---------------------------- FUNCTIONS ----------------------------------------

# Get date/time of all samples taken (sample_times)
def get_sample_times():
    sample_names = [f.name for f in os.scandir(samples_path) if f.is_dir()]
    
    for i in len(sample_names):
        sample_names[i]
        
            

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
    images_thread = threading.Thread(target = images_thread_cb)
    images_thread.daemon = True
    images_thread.start()