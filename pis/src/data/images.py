# 
# images.py
#
# Andreas Holleland
# 2023
#

#---------------------------- PACKAGES -----------------------------------------

import base64
import shutil
import threading
import os
import time

import mqtt.mqtt_client as client


#---------------------------- GLOBALS ------------------------------------------

# Storage location for samples and images
samples_path = '/home/pi/OtterUSV-PlanktonSystem/pis/data/db_images'
samples_path2 = '/home/pi/OtterUSV-PlanktonSystem/pis/data/db_images/'

# Current selected sample/image
curr_sample = 0
curr_image = 0

# Flags
samples_request = False
images_request = False
image_request = False


#---------------------------- FUNCTIONS ----------------------------------------

# --- Creates a time/position tagged sample directory ---
def create_sample_dir(lat, lon):
    sample_time = time.strftime('%Y%m%d%H%M%S')
    sample_dir = samples_path2 + sample_time

    pos_file = sample_dir + '/' + lat + ',' + lon + '.txt'

    os.mkdir(sample_dir)
    open(pos_file, 'a').close()

    return sample_dir

# --- Removes a time/position tagged sample directory ---
def remove_sample_dir(dir):
    try:
        shutil.rmtree(dir, ignore_errors=True)
    except:
        pass


# --- Generates a filename for an image within a sample ---
def create_image_path(sample_dir):
    image_time = time.strftime('%Y%m%d%H%M%S')
    image_path = sample_dir + '/' + image_time + '.jpg'

    return image_path


# --- Get date/time of all samples ---
def get_samples():
    samples = [
        file.name for file in os.scandir(samples_path) if file.is_dir()
    ]
    samples = ','.join(samples)
    return samples


# --- Publish list of samples to MQTT broker ---
def publish_samples():
    client.publish_message(
        t = client.con.topic.DATA_SAMPLES,
        m = get_samples(),
        r = True,
    )
    

# --- Get date/time of all images within a sample ---
def get_images(sample):
    images_path = (samples_path + '/' + sample)

    images = []
    pos = ''
    
    for file in os.scandir(images_path):
        if file.name.endswith('g'):
            images.append(file.name[:-4]) 
        else:
            pos = file.name[:-4]

    images = ','.join(images)
    images = images + ',' + pos
    return images


# --- Publish list of images to MQTT broker ---
def publish_images(images):
    client.publish_message(
        t = client.con.topic.DATA_IMAGES,
        m = images,
        r = True,
    )


# --- Get a specific image within a sample ---
def get_image(sample, image_time):
    image = (samples_path + '/' + sample + '/' + image_time)
    return image


# --- Publish an image within a sample to MQTT broker ---
def publish_image(image):
    client.publish_message(
        t = client.con.topic.DATA_IMAGE,
        m = image,
        r = True,
    )


# --- Set sample request flag ---
def set_sample_request_flag():
    global samples_request
    samples_request = True


# --- Set current sample directory and image request flag ---
def set_curr_sample(sample):
    global curr_sample, images_request
    curr_sample = sample
    images_request = True


# --- Set current image ---
def set_curr_image(image):
    global curr_image, image_request
    curr_image = image
    image_request = True


# --- Images thread callback function --
def images_thread_cb():
    global samples_request, images_request, image_request
    while True:

        # If list of samples have been requested from MQTT broker
        if(samples_request == True):

            # Publish
            publish_samples()

            # Reset flag
            samples_request = False

            # Sleep for 1ms
            time.sleep(0.001)

        # If list of images have been requested from MQTT broker
        if(images_request == True):
            # Get images corresponding to selected sample
            images = get_images(curr_sample.decode())

            # Publish
            publish_images(images)

            # Reset flag
            images_request = False

            # Sleep for 1ms
            time.sleep(0.001)

        # If an image has been requested from MQTT broker
        if(image_request == True):
            img_file = curr_image.decode() + '.jpg'

            # Get image path
            image_path = get_image(curr_sample.decode(), img_file)

            # Read image file
            try:
                with open(image_path, 'rb') as image:
                    img = image.read()
            
            # If image doesn't exist, ignore request
            except:
                continue
            
            # If image exists, encode and publish image
            else:
                # Convert image to a base64 String for transmission
                message = img
                base64_bytes = base64.b64encode(message)
                base64_string = base64_bytes.decode('ascii')

                # Publish image
                publish_image(base64_string)

            # Reset flag
            image_request = False

            # Sleep for 1ms
            time.sleep(0.001)

        # If nothing is happening, sleep thread
        else:
            time.sleep(0.001)


# Initialize images thread
def init_images_thread():
    images_thread = threading.Thread(target = images_thread_cb)
    images_thread.daemon = True
    images_thread.start()