# 
# mqtt_logger.py
#
# Andreas Holleland
# 2023
#

#---------------------------- PACKAGES -----------------------------------------

from enum import Enum
import time
import numpy as np
import paho.mqtt.client             as mqtt
import mqtt_constants               as con


#---------------------------- GLOBALS ------------------------------------------

clientname = "pis_logger"
client = mqtt.Client(client_id=clientname, clean_session=True)

# Topics to be monitored
topics_sub = [
    # Vehicle position
    con.topic.VEHICLE_POS,

    # State
    con.topic.STATUS_FLAGS,

    # Connection
    con.topic.STATUS_CONNECTED,

    # Begin sampling control command
    con.topic.CTRL_SAMPLE,

    # Manual imaging
    con.topic.CTRL_IMAGE,
    con.topic.IMAGE,

    # 5V pump
    con.topic.CTRL_SAMPLE_PUMP,
    con.topic.CTRL_STOP,

    # RMS control commands
    con.topic.CTRL_RMS_FILL,
    con.topic.CTRL_RMS_FLUSH,
    con.topic.CTRL_RMS_STOP,

    # Microscope position
    con.topic.CAL_CURRPOS,
    con.topic.CAL_NEXTPOS,

    # LED Brightness
    con.topic.CAL_CURRLED,
    con.topic.CAL_NEXTLED,

    # Image file system
    con.topic.GET_SAMPLES,
    con.topic.GET_IMAGES,
    con.topic.GET_IMAGE,
    con.topic.DATA_IMAGE,
    con.topic.DATA_IMAGES,
    con.topic.DATA_SAMPLES,
    con.topic.RM_SAMPLE
]

# System state flags
class status_flag(int, Enum):
    
    # RMS
    RMS_PUMP        = 0
    RMS_VALVE       = 1
    RMS_FULL        = 2
    RMS_LEAK        = 3

    # PIS
    READY           = 4
    SAMPLING        = 5
    PUMP            = 6
    IMAGING         = 7
    CALIBRATING     = 8
    LEAK            = 9

# System state
sys_state = 0

# Message queue: string element = {timestamp,topic,data}
msgs = []

timestamps   = []
topics       = []
messages     = []


#---------------------------- FUNCTIONS ----------------------------------------

# --- Initialize MQTT client thread ---
def init_mqtt_thread():
    
    # Set callbacks
    client.on_connect = on_connect
    client.on_message = on_message

    # Connect and start thread
    client.connect(con.broker)
    client.loop_start()


# --- On-connect callback function ---
def on_connect(client, userdata, flags, rc):
    # If connection succeeds
    if(rc == 0):
        print("\n" + "# Connection succeeded")

        # Subscribe to relevant topics with QOS=1
        for topic in topics_sub:
            client.subscribe(topic, 1)
        print("\n" + "# Subscribed to topics")

    # If connection fails
    else:
        print("\n" + "# Connection failed, returned code: ", rc)


# --- On-message received callback function ---
def on_message(client, userdata, message):
    global timestamps, topics, messages
    # Get values
    timestamp = time.strftime('%Y/%m/%d %H:%M:%S')
    topic = str(message.topic)
    message = str(message.payload)

    # Enqueue values
    timestamps.append(timestamp)
    topics.append(topic)
    messages.append(message)


# --- Init ---
init_mqtt_thread()
filename = '../logs/' + time.strftime('%Y%m%d%H%M%S') + '.txt'
f = open(filename, 'a')
f.write('MQTT LOG ' + time.strftime('%Y/%m/%d %H:%M:%S') + '\n')
f.close()

# --- Main thread ---
while(True):
    if(len(topics) > 0):

        # Extract the three elements
        timestamp = timestamps[0]
        topic = topics[0]
        message = (messages[0])[2:-1]
        
        # Open the file in append mode
        f = open(filename, 'a')

        # Log the timestamp/topic received
        string = "#" + " ["+timestamp+"]" + " ["+topic+"]"
        f.write("\n" + string)

        # Log the payload/message
        if((topic == con.topic.IMAGE) or (topic == con.topic.DATA_IMAGE)):
            f.write("\n" + str(len(message)) + " bytes")

        elif((topic == con.topic.DATA_SAMPLES) or (topic == con.topic.DATA_IMAGES)):
            try:
                values = message.split(',')
                for value in values:
                    f.write("\n  " + value)
            except:
                pass

        elif(topic == con.topic.STATUS_FLAGS):
            try:
                f.write("\n" + bin(int(message)))
            except:
                pass
        
        else:
            f.write("\n" + message)

        timestamps.pop(0)
        topics.pop(0)
        messages.pop(0)
        f.close()
    else:
        time.sleep(0.001)