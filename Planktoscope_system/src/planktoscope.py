#
# Andreas Hølleland
# 2022
#

from picamera import PiCamera

camera = PiCamera()

def takePicture():
    path = '/home/pi/planktoPython/OtterUSV-PlanktonSystem/Planktoscope_system/data/image.jpg'
    camera.capture(path)
