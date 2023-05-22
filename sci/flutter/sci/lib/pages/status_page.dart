import "package:flutter/material.dart";

import "package:sci/constants.dart";

import "package:sci/controllers/mqtt_controller.dart";

import "package:sci/widgets/StatusTab.dart";

class StatusPage extends StatefulWidget {
  // MQTT Client
  MQTTController mqtt;

  // Constructor
  StatusPage(this.mqtt);

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  int connected = 0;
  int sampling = 0;
  int leak = 0;
  int rms_pump = 0;
  int rms_valve = 0;
  int rms_full = 0;
  int rms_leak = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      // Main column
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

        // Column elements
        children: <Widget>[
          // Status flags
          ValueListenableBuilder<int>(
            builder: (BuildContext context, int value, Widget? child) {
              rms_pump = (value >> 0) & 1;
              rms_valve = (value >> 1) & 1;
              rms_full = (value >> 2) & 1;
              rms_leak = (value >> 3) & 1;
              connected = (value >> 4) & 1;
              sampling = (value >> 5) & 1;
              leak = (value >> 6) & 1;

              // Box around status flags
              return Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(15),
                ),

                // Column for all the status flags
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    StatusTab('Connected', connected),
                    StatusTab('Sampling', sampling),
                    StatusTab('Leak', leak),
                    StatusTab('RMS Pump', rms_pump),
                    StatusTab('RMS Valve', rms_valve),
                    StatusTab('RMS Full', rms_full),
                    StatusTab('RMS Leak', rms_leak),
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
                fontSize: 20,
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
