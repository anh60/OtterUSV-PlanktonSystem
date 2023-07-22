// ignore: slash_for_doc_comments
/**
 * status_boxes.dart
 * 
 * Andreas Holleland
 * 2023
 */

import 'package:flutter/material.dart';
import 'package:sci/widgets/status_page/status_boxes/reservoir_box.dart';
import 'package:sci/widgets/status_page/status_boxes/sample_box.dart';
import 'package:sci/widgets/status_page/status_boxes/status_box.dart';

import '../../constants.dart';
import '../../controllers/mqtt_controller.dart';
import '../../controllers/status_controller.dart';
import 'status_boxes/calibration_box.dart';

class StatusBoxes extends StatelessWidget {
  final StatusController status;
  final MQTTController mqtt;

  const StatusBoxes(this.status, this.mqtt, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Configuration
      width: getContainerWidth(context, div, rightRatio),
      height: 325,

      // Horizontal scroll
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // PIS container
          ValueListenableBuilder<String>(
            valueListenable: mqtt.status_flags,
            builder: (BuildContext context, String value, Widget? child) {
              status.setStatus(value);
              return StatusBox(
                status.pscope.label,
                status.pscope.flagLabels,
                status.pscope.flags,
              );
            },
          ),

          // Horizontal gap
          const SizedBox(width: 15),

          // RMS container
          ValueListenableBuilder<String>(
            valueListenable: mqtt.status_flags,
            builder: (BuildContext context, String value, Widget? child) {
              status.setStatus(value);
              return StatusBox(
                status.rms.label,
                status.rms.flagLabels,
                status.rms.flags,
              );
            },
          ),

          // Horizontal gap
          const SizedBox(width: 15),

          // Sample routine box
          SampleBox(),

          // Horizontal gap
          const SizedBox(width: 15),

          // Microscope calibration box
          CalibrationBox(mqtt),

          // Horizontal gap
          const SizedBox(width: 15),

          // Reservoir status box
          ReservoirBox(),
        ],
      ),
    );
  }
}
