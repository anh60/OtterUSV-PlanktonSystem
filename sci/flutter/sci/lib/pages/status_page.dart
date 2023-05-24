import "package:flutter/material.dart";

import "package:sci/constants.dart";
import "package:sci/controllers/mqtt_controller.dart";
import "package:sci/widgets/status_box.dart";

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
  int calibrating = 0;
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
          ValueListenableBuilder<String>(
            builder: (BuildContext context, String value, Widget? child) {
              int status = int.parse(value);
              rms_pump = (status >> 0) & 1;
              rms_valve = (status >> 1) & 1;
              rms_full = (status >> 2) & 1;
              rms_leak = (status >> 3) & 1;
              connected = (status >> 4) & 1;
              sampling = (status >> 5) & 1;
              leak = (status >> 6) & 1;
              calibrating = (status >> 7) & 1;

              return SizedBox(
                height: 360,
                width: 1320,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    StatusBox(
                      'Connected',
                      connected,
                      'Sampling',
                      sampling,
                      'Calibrating',
                      calibrating,
                      'Leak',
                      leak,
                      'RMS Pump',
                      rms_pump,
                      'RMS Valve',
                      rms_valve,
                      'RMS Full',
                      rms_full,
                      'RMS Leak',
                      rms_leak,
                    ),
                    StatusBox(
                      'Connected',
                      connected,
                      'Sampling',
                      sampling,
                      'Calibrating',
                      calibrating,
                      'Leak',
                      leak,
                      'RMS Pump',
                      rms_pump,
                      'RMS Valve',
                      rms_valve,
                      'RMS Full',
                      rms_full,
                      'RMS Leak',
                      rms_leak,
                    ),
                    StatusBox(
                      'Connected',
                      connected,
                      'Sampling',
                      sampling,
                      'Calibrating',
                      calibrating,
                      'Leak',
                      leak,
                      'RMS Pump',
                      rms_pump,
                      'RMS Valve',
                      rms_valve,
                      'RMS Full',
                      rms_full,
                      'RMS Leak',
                      rms_leak,
                    ),
                    StatusBox(
                      'Connected',
                      connected,
                      'Sampling',
                      sampling,
                      'Calibrating',
                      calibrating,
                      'Leak',
                      leak,
                      'RMS Pump',
                      rms_pump,
                      'RMS Valve',
                      rms_valve,
                      'RMS Full',
                      rms_full,
                      'RMS Leak',
                      rms_leak,
                    ),
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
