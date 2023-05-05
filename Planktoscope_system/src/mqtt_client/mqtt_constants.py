# mqtt_constants.py
#
# Andreas Holleland
# 2023
#

from enum import Enum

broker = "mqtt.eclipseprojects.io"

class topic(str, Enum):
    STATUS  = "planktoscope_status"
    SAMPLE  = "planktoscope_sample"
    POS     = "planktoscope_pos"