// ignore: slash_for_doc_comments
/**
 * mqtt_controller.dart
 * 
 * Andreas Holleland
 * 2023
 */

//---------------------------- PACKAGES ----------------------------------------

import "package:flutter/material.dart";
import "package:mqtt_client/mqtt_client.dart";
import "package:mqtt_client/mqtt_server_client.dart";
import "package:sci/constants.dart";

//---------------------------- CONTROLLER --------------------------------------

class MQTTController with ChangeNotifier {
  // Value notifiers
  final ValueNotifier<String> status_connected = ValueNotifier<String>('0');
  final ValueNotifier<String> status_flags = ValueNotifier<String>('0');
  final ValueNotifier<String> cal_pos = ValueNotifier<String>('0');
  final ValueNotifier<String> cal_led = ValueNotifier<String>('0');
  final ValueNotifier<String> image = ValueNotifier<String>('0');
  final ValueNotifier<String> data_samples = ValueNotifier<String>('0');
  ValueNotifier<String> data_images = ValueNotifier<String>('0');
  final ValueNotifier<String> data_image = ValueNotifier<String>('0');

  // Client to be initialized
  late MqttServerClient client;

  //---------------------------- OBJECT ----------------------------------------

  Future<Object> connect() async {
    //---------------------------- SETTINGS ------------------------------------

    client = MqttServerClient.withPort(
        mqtt_broker, mqtt_client_name, mqtt_broker_port);
    client.logging(on: false);
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.onSubscribed = onSubscribed;
    client.onSubscribeFail = onSubscribeFail;
    client.pongCallback = pong;
    //client.keepAlivePeriod = 60;
    client.logging(on: false);
    client.setProtocolV311();

    //---------------------------- INIT ----------------------------------------

    // Configure connection will-message and set clean session
    final connMessage = MqttConnectMessage()
        .withWillTopic('pscope_sci_lw')
        .withWillMessage('lw')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    // Connect to broker
    print('MQTT | Client connecting....');
    client.connectionMessage = connMessage;
    try {
      await client.connect();
    } catch (e) {
      print('Exception: $e');
      client.disconnect();
    }

    // Check if connected, if not disconnect properly
    if (client.connectionStatus!.state != MqttConnectionState.connected) {
      print('MQTT | Connection failed, status = ${client.connectionStatus}');
      client.disconnect();
      return -1;
    }

    //---------------------------- LOOP ----------------------------------------

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? msg) {
      // Convert payload to MqttPublishMessage
      final data = msg![0].payload as MqttPublishMessage;

      // Get Uint8Buffer message
      var message = data.payload.message;

      // Convert Uint8Buffer to String
      String stringMsg = MqttPublishPayload.bytesToStringAsString(message);

      // Get topic
      String topic = msg[0].topic;

      // Filter messages and update corresponding ValueNotifier
      filterMessages(topic, stringMsg);

      print('MQTT | Data received on topic: $topic');
      print('MQTT | Payload size = ${message.length}');
      print('');
    });

    return client;
  }

  //---------------------------- FUNCTIONS -------------------------------------

  void onConnected() {
    // Subscribe to topics
    client.subscribe(topics.STATUS_FLAGS, MqttQos.atLeastOnce);
    client.subscribe(topics.STATUS_CONNECTED, MqttQos.atLeastOnce);
    client.subscribe(topics.CAL_CURRPOS, MqttQos.atLeastOnce);
    client.subscribe(topics.CAL_CURRLED, MqttQos.atLeastOnce);
    client.subscribe(topics.IMAGE, MqttQos.atLeastOnce);
    client.subscribe(topics.DATA_SAMPLES, MqttQos.atLeastOnce);
    client.subscribe(topics.DATA_IMAGES, MqttQos.atLeastOnce);
    client.subscribe(topics.DATA_IMAGE, MqttQos.atLeastOnce);
    print('MQTT | Connected');
  }

  void onDisconnected() {
    print('MQTT | Disconnected');
  }

  void onSubscribed(String topic) {
    print('MQTT | Subscribed topic: $topic');
  }

  void onSubscribeFail(String topic) {
    print('MQTT | Failed to subscribe $topic');
  }

  void onUnsubscribed(String? topic) {
    print('MQTT | Unsubscribed topic: $topic');
  }

  void pong() {
    print('MQTT | Ping response client callback invoked');
  }

  void publishMessage(String t, String m) {
    print('publishing');
    final builder = MqttClientPayloadBuilder();
    builder.addString(m);
    client.publishMessage(
      t,
      MqttQos.atLeastOnce,
      builder.payload!,
      retain: false,
    );
  }

  void pubRetainedMessage(String t, String m) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(m);
    client.publishMessage(
      t,
      MqttQos.atLeastOnce,
      builder.payload!,
      retain: true,
    );
  }

  void filterMessages(String t, String m) {
    switch (t) {
      case topics.STATUS_CONNECTED:
        status_connected.value = m;
        break;
      case topics.STATUS_FLAGS:
        status_flags.value = m;
        break;
      case topics.CAL_CURRPOS:
        cal_pos.value = m;
        break;
      case topics.CAL_CURRLED:
        cal_led.value = m;
        break;
      case topics.IMAGE:
        image.value = m;
        break;
      case topics.DATA_SAMPLES:
        data_samples.value = m;
        break;
      case topics.DATA_IMAGES:
        data_images.value = m;
        break;
      case topics.DATA_IMAGE:
        data_image.value = m;
        break;
      default:
    }
  }
}
