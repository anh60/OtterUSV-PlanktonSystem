# Andreas Hølleland
# 2022

from picamera import PiCamera

camera = PiCamera()

def takePicture():
    path = '/home/pi/planktoPython/pictures/OtterUSV-PlanktonSystem/Planktoscope_system/pictures/image.jpg'
    camera.capture(path)
