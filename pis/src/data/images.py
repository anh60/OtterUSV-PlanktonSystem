# 
# images.py
#
# Andreas Holleland
# 2023
#

#---------------------------- PACKAGES -----------------------------------------

import threading
import os
import time

import mqtt.mqtt_client as client


#---------------------------- GLOBALS ------------------------------------------

# Storage location for samples and images
samples_path = '/home/pi/OtterUSV-PlanktonSystem/pis/data/db_images'

# Current selected sample/image
curr_sample = 0
curr_image = 0

# Flags
images_request = False
image_request = False


#---------------------------- FUNCTIONS ----------------------------------------

# Get date/time of all samples
def get_samples():
    samples = [
        file.name for file in os.scandir(samples_path) if file.is_dir()
    ]
    samples = ','.join(samples)
    return samples


# Publish list of samples to MQTT broker
def send_samples():
    client.pub_sample_times(get_samples())
            

# Get date/time of all images within a sample
def get_images(sample):
    images_path = (samples_path + '/' + sample)
    images = [
        file.name for file in os.scandir(images_path)
    ]
    images = ','.join(images)
    return images


# Get a specific image within a sample
def get_image(sample, image_time):
    image = (samples_path + '/' + sample + '/' + image_time)
    return image


# Set current sample
def set_curr_sample(sample):
    global curr_sample, images_request
    curr_sample = sample
    images_request = True


# Set current image
def set_curr_image(image):
    global curr_image, image_request
    curr_image = image
    image_request = True


# Images thread callback function
def images_thread_cb():
    global images_request, image_request
    while True:
        if(images_request == True):
            print(curr_sample)

            # Get images corresponding to selected sample
            images = get_images(curr_sample)

            # Publish images
            client.pub_image_times(images)

            # Reset flag
            images_request = False

            # Sleep for 1ms
            time.sleep(0.001)

        if(image_request == True):
            # Sleep for 1ms
            time.sleep(0.001)

        else:
            # Sleep for 1ms
            time.sleep(0.001)


# Initialize images thread
def init_images_thread():
    images_thread = threading.Thread(target = images_thread_cb)
    images_thread.daemon = True
    images_thread.start()