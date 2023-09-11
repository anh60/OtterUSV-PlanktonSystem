# 
# mqtt_client.py
#
# Andreas Holleland
# 2023
#

#---------------------------- PACKAGES -----------------------------------------

import paho.mqtt.client             as mqtt
import mqtt.mqtt_constants          as con


#---------------------------- GLOBALS ------------------------------------------

clientname = "pscope_pis"
client = mqtt.Client(client_id=clientname, clean_session=True)


# Topics subscribed to by the PIS
topics_sub = [

    # Vehicle position
    con.topic.VEHICLE_POS,

    # PIS sample routine
    con.topic.CTRL_SAMPLE,

    # PIS config
    con.topic.CAL_NEXTPOS,
    con.topic.CAL_NEXTLED,

    # PIS manual control
    con.topic.CTRL_IMAGE,
    con.topic.CTRL_SAMPLE_PUMP,

    # RMS manual control
    con.topic.CTRL_RMS_FILL,
    con.topic.CTRL_RMS_FLUSH,
    con.topic.CTRL_RMS_STOP,

    # Images file system
    con.topic.GET_SAMPLES,
    con.topic.GET_IMAGES,
    con.topic.GET_IMAGE
    
]

# MQTT data received queue
topics = []
messages = []


#---------------------------- FUNCTIONS ----------------------------------------

# --- Initialize MQTT client thread ---
def init_mqtt_thread():
    
    # Set callbacks
    client.on_connect = on_connect
    client.on_message = on_message

    # Set last-will topic
    client.will_set(
        con.topic.STATUS_CONNECTED, 0, 1, True
    )

    # Connect and start thread
    client.connect(con.broker)
    client.loop_start()


# --- On-connect callback function ---
def on_connect(client, userdata, flags, rc):

    # If connection succeeds
    if(rc == 0):
        # Publish to connected topic
        client.publish(
            con.topic.STATUS_CONNECTED, 1, 1, True
        )

    # If connection fails
    else:
        #print("Connection failed, returned code: ", rc)
        pass

    # Subscribe to relevant topics with QOS=1
    for topic in topics_sub:
        client.subscribe(topic, 1)


# --- On-message received callback function ---
def on_message(client, userdata, message):
    global topics, messages
    topic = message.topic
    msg = message.payload
    topics.append(topic)
    messages.append(msg)


# --- Publish a message with QOS=1 ---
def publish_message(t, m, r):
    client.publish(
        topic   = t,
        payload = m,
        qos     = 1,
        retain  = r
    )

# --- Get topic/message queues ---
def get_msgs():
    global topics, messages
    return topics, messages


# --- Dequeue first element in topic/message queue ---
def dequeue_msgs():
    global topics, messages
    topics.pop(0)
    messages.pop(0)