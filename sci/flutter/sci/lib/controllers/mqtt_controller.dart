import "package:flutter/material.dart";
import "package:mqtt_client/mqtt_client.dart";
import "package:mqtt_client/mqtt_server_client.dart";

import "package:sci/constants.dart";

class MQTTController with ChangeNotifier {
  // Status notifiers
  final ValueNotifier<int> status_flags = ValueNotifier<int>(0);

  // Calibration notifiers
  final ValueNotifier<int> cal_pos = ValueNotifier<int>(0);
  final ValueNotifier<int> cal_photo = ValueNotifier<int>(0);

  // Client to be initialized
  late MqttServerClient client;

  // Configure MQTT Client
  Future<Object> connect() async {
    client = MqttServerClient.withPort(
        mqtt_broker, mqtt_client_name, mqtt_broker_port);
    client.logging(on: true);
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.onSubscribed = onSubscribed;
    client.onSubscribeFail = onSubscribeFail;
    client.pongCallback = pong;
    client.keepAlivePeriod = 60;
    client.logging(on: true);
    client.setProtocolV311();

    final connMessage = MqttConnectMessage()
        .withWillTopic('willtopic')
        .withWillMessage('Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    print('MQTT_LOGS::Mosquitto client connecting....');

    client.connectionMessage = connMessage;
    try {
      await client.connect();
    } catch (e) {
      print('Exception: $e');
      client.disconnect();
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('MQTT_LOGS::Mosquitto client connected');
    } else {
      print(
          'MQTT_LOGS::ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}');
      client.disconnect();
      return -1;
    }

    print('MQTT_LOGS::Subscribing to the status topic');
    client.subscribe(topics.STATUS_FLAGS, MqttQos.atLeastOnce);
    client.subscribe(topics.STATUS_CONNECTED, MqttQos.atLeastOnce);
    client.subscribe(topics.CAL_CURRPOS, MqttQos.atLeastOnce);
    client.subscribe(topics.CAL_PHOTO, MqttQos.atLeastOnce);

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;

      String pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      int data = int.parse(pt);

      switch (c[0].topic) {
        case topics.STATUS_FLAGS:
          status_flags.value = data;
          break;
        case topics.CAL_CURRPOS:
          cal_pos.value = data;
          break;
        case topics.CAL_PHOTO:
          cal_photo.value = data;
          break;
        default:
      }

      print(
          'MQTT_LOGS:: New data arrived: topic is <${c[0].topic}>, payload is $pt');
      print('');
    });

    return client;
  }

  void onConnected() {
    print('MQTT_LOGS:: Connected');
  }

  void onDisconnected() {
    print('MQTT_LOGS:: Disconnected');
  }

  void onSubscribed(String topic) {
    print('MQTT_LOGS:: Subscribed topic: $topic');
  }

  void onSubscribeFail(String topic) {
    print('MQTT_LOGS:: Failed to subscribe $topic');
  }

  void onUnsubscribed(String? topic) {
    print('MQTT_LOGS:: Unsubscribed topic: $topic');
  }

  void pong() {
    print('MQTT_LOGS:: Ping response client callback invoked');
  }

  void publishMessage(String t, String m) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(m);
    client.publishMessage(t, MqttQos.atLeastOnce, builder.payload!);
  }
}
