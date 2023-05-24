import "dart:convert";

import "package:flutter/material.dart";

import "package:sci/constants.dart";

import "package:sci/controllers/mqtt_controller.dart";
import 'package:sci/widgets/status_tab.dart';

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
          // Image
          ValueListenableBuilder<String>(
            builder: (BuildContext context, String value, Widget? child) {
              var bytesImage = const Base64Decoder().convert(value);
              return Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 77, 90, 114),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.memory(
                  bytesImage,
                  scale: 2,
                ),
              );
            },
            valueListenable: widget.mqtt.cal_photo,
          ),

          // Current position
          ValueListenableBuilder<String>(
            builder: (BuildContext context, String value, Widget? child) {
              int currPos = int.parse(value);
              return Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    StatusTab('Current value', currPos),
                  ],
                ),
              );
            },
            valueListenable: widget.mqtt.cal_pos,
          ),

          // Next value
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                StatusTab('New value', 1000),
              ],
            ),
          ),

          // Calibrate Button
          FloatingActionButton.extended(
            label: const Text(
              'Change Position',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            backgroundColor: Colors.blueGrey,
            elevation: 5,
            hoverColor: const Color.fromARGB(255, 126, 151, 194),
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
