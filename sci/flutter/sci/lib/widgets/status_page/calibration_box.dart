import "package:flutter/material.dart";
import "package:sci/constants.dart";
import "package:sci/widgets/outlined_button_dark.dart";
import "package:sci/widgets/outlined_text_field.dart";
import "package:sci/widgets/status_page/status_container.dart";
import "package:sci/widgets/status_page/status_tab.dart";

import "../../controllers/mqtt_controller.dart";

class CalibrationBox extends StatefulWidget {
  final MQTTController mqtt;

  const CalibrationBox(this.mqtt, {super.key});

  @override
  State<CalibrationBox> createState() => _CalibrationBoxState();
}

class _CalibrationBoxState extends State<CalibrationBox> {
  final textFieldController = TextEditingController();

  @override
  void dispose() {
    textFieldController.dispose();
    super.dispose();
  }

  void onSendPressed() {
    widget.mqtt.publishMessage(
        topics.CAL_NEXTPOS, textFieldController.text.toString());
  }

  @override
  Widget build(BuildContext context) {
    return StatusContainer(
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // Vertical gap
          const SizedBox(height: 5),

          // Label
          const Text(
            'MICROSCOPE',
            style: TextStyle(
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
              return StatusTab('Position', currPos);
            },
          ),

          // Vertical gap
          const SizedBox(height: 30),

          // New position text field
          OutlinedTextField(
            textFieldController,
            'New pos',
            true,
          ),

          // Vertical gap
          const SizedBox(height: 15),

          // Send new position button¨
          OutlinedButtonDark(
            onSendPressed,
            'Send',
            false,
          ),

          // Vertical gap
          const SizedBox(height: 30),

          // Image received date
          // Label
          const Text(
            'Image receieved',
            style: TextStyle(color: lightBlue),
          ),

          // Vertical gap
          const SizedBox(height: 5),

          // Date
          const Text(
            '05/07/2023/20:00',
            style: TextStyle(color: lightBlue),
          ),
        ],
      ),
    );
  }
}
