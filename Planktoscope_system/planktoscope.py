# Andreas Hølleland
# 2022

from picamera import PiCamera

camera = PiCamera()

def takePicture():
    camera.capture('/pictures/image.jpg')
