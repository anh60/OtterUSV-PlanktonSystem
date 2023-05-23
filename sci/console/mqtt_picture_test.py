import paho.mqtt.client as mqtt
import mqtt_constants as con
import base64

# The callback for when the client receives a CONNACK response from the server.
def on_connect(client, userdata, flags, rc):
  print("Connected with result code "+str(rc))
  # Subscribing in on_connect() means that if we lose the connection and
  # reconnect then subscriptions will be renewed.
  client.subscribe(con.topic.CAL_PHOTO)
  
# The callback for when a PUBLISH message is received from the server.
def on_message(client, userdata, message):
  msg = str(message.payload.decode('utf-8'))

  img = msg.encode("ascii")

  final_msg = base64.b64decode(img)

  open('receive.jpg', 'wb').write(final_msg)
  
  print('image received')
  
client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message
client.connect(con.broker)

# Blocking call that processes network traffic, dispatches callbacks and
# handles reconnecting.
# Other loop*() functions are available that give a threaded interface and a
# manual interface.
client.loop_forever()