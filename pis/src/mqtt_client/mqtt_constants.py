# mqtt_constants.py
#
# Andreas Holleland
# 2023
#

from enum import Enum

broker = "mqtt.eclipseprojects.io"

class topic(str, Enum):
    STATUS_FLAGS        = "planktoscope/status/flags"
    STATUS_CONNECTED    = "planktoscope/status/connected"

    CTRL_SAMPLE         = "planktoscope/control/sample"
    CTRL_SAMPLE_PUMP    = "planktoscope/control/sample_pump"
    CTRL_STOP           = "planktoscope/control/stop"
    
    CTRL_RMS_PUMP       = "planktoscope/control/pump"
    CTRL_RMS_VALVE      = "planktoscope/control/valve"
    CTRL_RMS_STOP       = "planktoscope/control/stop"

    CAL_CURRPOS         = "planktoscope/calibrate/currpos"
    CAL_NEXTPOS         = "planktoscope/calibrate/nextpos"
    CAL_PHOTO           = "planktoscope/calibrate/photo"
