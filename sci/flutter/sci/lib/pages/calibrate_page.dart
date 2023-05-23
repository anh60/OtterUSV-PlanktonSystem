import "package:flutter/material.dart";

import "package:sci/constants.dart";

import "package:sci/controllers/mqtt_controller.dart";
import "package:sci/widgets/StatusTab.dart";

class CalibratePage extends StatefulWidget {
  // MQTT Client
  MQTTController mqtt;

  // Constructor
  CalibratePage(this.mqtt);

  @override
  State<CalibratePage> createState() => _CalibratePageState();
}

class _CalibratePageState extends State<CalibratePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          // Picture
          ValueListenableBuilder<int>(
            builder: (BuildContext context, int value, Widget? child) {
              return Container();
            },
            valueListenable: widget.mqtt.cal_photo,
          ),

          // Current position
          ValueListenableBuilder<int>(
            builder: (BuildContext context, int value, Widget? child) {
              return Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    StatusTab('Current value', 1000),
                  ],
                ),
              );
            },
            valueListenable: widget.mqtt.cal_pos,
          ),
          // Calibrate Button
          FloatingActionButton.extended(
            label: const Text(
              'Change Position',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            backgroundColor: Colors.blueGrey,
            elevation: 5,
            hoverColor: Color.fromARGB(255, 126, 151, 194),
            hoverElevation: 10,
            splashColor: Colors.blue,
            onPressed: () {
              widget.mqtt.publishMessage(topics.CAL_NEXTPOS, '1');
            },
          ),
        ],
      ),
    );
  }
}
