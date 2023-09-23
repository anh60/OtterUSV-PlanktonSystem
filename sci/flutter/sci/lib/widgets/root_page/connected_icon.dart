import 'package:flutter/material.dart';
import 'package:sci/controllers/mqtt_controller.dart';

class ConnectedIcon extends StatelessWidget {
  final MQTTController mqtt;
  const ConnectedIcon(this.mqtt, {super.key});

  Icon setConnectionIcon(int connection) {
    if (connection == 1) {
      return const Icon(Icons.wifi, color: Colors.green);
    }
    return const Icon(Icons.wifi_off, color: Colors.red);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: ValueListenableBuilder<String>(
            valueListenable: mqtt.status_connected,
            builder: (BuildContext context, String value, Widget? child) {
              int connection = int.parse(value);
              return setConnectionIcon(connection);
            },
          ),
        ),
      ),
    );
  }
}
