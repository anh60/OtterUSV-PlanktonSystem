# mqtt_constants.py
#
# Andreas Holleland
# 2023
#

from enum import Enum

broker = "mqtt.eclipseprojects.io"

class topic(str, Enum):

    # PIS and RMS status flags
    STATUS_FLAGS        = "planktoscope/status/flags"

    # connected flag (last will)
    STATUS_CONNECTED    = "planktoscope/status/connected"

    # begin sampling routine
    CTRL_SAMPLE         = "planktoscope/control/sample"

    # 5v pump on/off
    CTRL_SAMPLE_PUMP    = "planktoscope/control/sample_pump"
    CTRL_STOP           = "planktoscope/control/stop"
    
    # RMS fill, flush, stop (manual control)
    CTRL_RMS_FILL       = "planktoscope/control/pump"
    CTRL_RMS_FLUSH      = "planktoscope/control/valve"
    CTRL_RMS_STOP       = "planktoscope/control/stop"

    # Camera currPos, newpos, and take mqtt photo
    CAL_CURRPOS         = "planktoscope/calibrate/currpos"
    CAL_NEXTPOS         = "planktoscope/calibrate/nextpos"
    CAL_PHOTO           = "planktoscope/calibrate/photo"
