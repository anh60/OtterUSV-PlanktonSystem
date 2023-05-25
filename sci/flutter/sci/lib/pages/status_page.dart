import "package:flutter/material.dart";

import "package:sci/constants.dart";
import "package:sci/controllers/status_controller.dart";
import "package:sci/controllers/mqtt_controller.dart";
import "package:sci/widgets/status_box.dart";

class StatusPage extends StatefulWidget {
  MQTTController mqtt;
  StatusPage(this.mqtt);

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  StatusController status = StatusController();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ValueListenableBuilder<String>(
            builder: (BuildContext context, String value, Widget? child) {
              status.setStatus(value);
              return SizedBox(
                height: 360,
                width: 1320,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    StatusBox(status.pscope.flagLabels, status.pscope.flags),
                    StatusBox(status.rms.flagLabels, status.rms.flags),
                  ],
                ),
              );
            },
            valueListenable: widget.mqtt.status_flags,
          ),
          FloatingActionButton.extended(
            label: const Text(
              'Start Sampling',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            backgroundColor: Colors.blueGrey,
            elevation: 5,
            hoverColor: Color.fromARGB(255, 126, 151, 194),
            hoverElevation: 10,
            splashColor: Colors.blue,
            onPressed: () {
              widget.mqtt.publishMessage(topics.CTRL_SAMPLE, '1');
            },
          ),
        ],
      ),
    );
  }
}
