// ignore: slash_for_doc_comments
/**
 * calibration_box.dart
 * 
 * Andreas Holleland
 * 2023
 */

import "package:flutter/material.dart";
import "package:sci/constants.dart";
import 'package:sci/widgets/general/outlined_button_dark.dart';
import 'package:sci/widgets/general/outlined_text_field.dart';
import 'package:sci/widgets/images_page/string_status_tab.dart';
import 'package:sci/widgets/status_page/status_boxes/status_container.dart';
import 'package:sci/widgets/status_page/status_boxes/status_tab.dart';

import '../../../controllers/mqtt_controller.dart';

class CalibrationBox extends StatefulWidget {
  final MQTTController mqtt;

  const CalibrationBox(this.mqtt, {super.key});

  @override
  State<CalibrationBox> createState() => _CalibrationBoxState();
}

class _CalibrationBoxState extends State<CalibrationBox> {
  final distanceFieldController = TextEditingController();
  final brightnessFieldController = TextEditingController();

  @override
  void dispose() {
    distanceFieldController.dispose();
    brightnessFieldController.dispose();
    super.dispose();
  }

  void sendDistance() {
    widget.mqtt.publishMessage(
        topics.CAL_NEXTPOS, distanceFieldController.text.toString());
    distanceFieldController.clear();
  }

  void sendBrightness() {
    widget.mqtt.publishMessage(
        topics.CAL_NEXTLED, brightnessFieldController.text.toString());
    brightnessFieldController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return StatusContainer(
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // Label
          const Text(
            'MICROSCOPE',
            style: TextStyle(
              fontSize: 12.5,
              color: lightBlue,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Vertical gap
          const SizedBox(height: 15),

          // Current position
          ValueListenableBuilder(
            valueListenable: widget.mqtt.cal_pos,
            builder: (BuildContext context, String value, Widget? child) {
              int currPos = int.parse(value);
              return StatusTab('Distance', currPos);
            },
          ),

          // Vertical gap
          const SizedBox(height: 5),

          // Max distance
          const StatusTab('Max distance', 40000),

          // Vertical gap
          const SizedBox(height: 5),

          // Min distance
          const StatusTab('Min distance', 5000),

          // Vertical gap
          const SizedBox(height: 5),

          // Current LED brightness
          ValueListenableBuilder(
            valueListenable: widget.mqtt.cal_led,
            builder: (BuildContext context, String value, Widget? child) {
              return StringStatusTab('LED Brightness (%)', value);
            },
          ),

          // Vertical gap
          const SizedBox(height: 30),

          // New position text field
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // New position text field
              OutlinedTextField(
                distanceFieldController,
                'Distance',
                false,
              ),

              // Send new position button
              OutlinedButtonDark(
                sendDistance,
                'Send',
                false,
              ),
            ],
          ),

          // Vertical gap
          const SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // New LED brightness field
              OutlinedTextField(
                brightnessFieldController,
                'Brightness',
                false,
              ),

              // Send new position button
              OutlinedButtonDark(
                sendBrightness,
                'Send',
                false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
