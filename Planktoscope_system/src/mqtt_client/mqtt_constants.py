# mqtt_constants.py
#
# Andreas Holleland
# 2023
#

from enum import Enum

broker = "mqtt.eclipseprojects.io"

class topic(str, Enum):
    STATUS          = "planktoscope/status/flags"
    CONNECTED       = "planktoscope/status/connected"
    CONTROL         = "planktoscope/control/sample"
    CAL_CURRPOS     = "planktoscope/calibrate/currpos"
    CAL_NEXTPOS     = "planktoscope/calibrate/nextpos"
    CAL_PHOTO       = "planktoscope/calibrate/photo"
