# mqtt_constants.py
#
# Andreas Holleland
# 2023
#

from enum import Enum

#broker = "mqtt.eclipseprojects.io"
broker = "broker.hivemq.com"

class topic(str, Enum):

    # --- Vehicle pos ---
    VEHICLE_POS         = "planktoscope/vehicle/position"

    # --- Status topics ---

    # PIS and RMS status flags
    STATUS_FLAGS        = "planktoscope/status/flags"

    # connected flag (last will)
    STATUS_CONNECTED    = "planktoscope/status/connected"


    # --- Control topics ---

    # Begin sampling routine
    CTRL_SAMPLE         = "planktoscope/control/sample"

    # Capture new image and publish
    CTRL_IMAGE          = "planktoscope/control/capture_image"

    # 5v pump on/off
    CTRL_SAMPLE_PUMP    = "planktoscope/control/sample_pump"
    CTRL_STOP           = "planktoscope/control/stop"
    
    # RMS fill, flush, stop (manual control)
    CTRL_RMS_FILL       = "planktoscope/control/pump"
    CTRL_RMS_FLUSH      = "planktoscope/control/valve"
    CTRL_RMS_STOP       = "planktoscope/control/stop"


    # --- Calibration topics ---

    # Camera currPos, newpos
    CAL_CURRPOS         = "planktoscope/calibrate/currpos"
    CAL_NEXTPOS         = "planktoscope/calibrate/nextpos"

    # LED brightness
    CAL_CURRLED         = "planktoscope/calibrate/currled"
    CAL_NEXTLED         = "planktoscope/calibrate/nextled"

    # Image from picamera
    IMAGE               = "planktoscope/calibrate/photo"


    # --- Images file system ---

    # Commands
    GET_SAMPLES        = "planktoscope/data/get_samples"
    GET_IMAGES         = "planktoscope/data/get_images"
    GET_IMAGE          = "planktoscope/data/get_image"  

    # Data
    DATA_SAMPLES        = "planktoscope/data/samples"
    DATA_IMAGES         = "planktoscope/data/images"
    DATA_IMAGE          = "planktoscope/data/image"

    RM_SAMPLE           = "planktoscope/data/rm_samples"

    