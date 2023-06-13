import "dart:convert";

import 'package:flutter/material.dart';

import 'package:sci/constants.dart';

import 'package:sci/controllers/mqtt_controller.dart';
import 'package:sci/widgets/container_scaled.dart';
import 'package:sci/widgets/outlined_button_dark.dart';
import 'package:sci/widgets/outlined_text_field.dart';

class CalibratePage extends StatefulWidget {
  // MQTT Client
  final MQTTController mqtt;

  // Constructor
  const CalibratePage(this.mqtt, {super.key});

  @override
  State<CalibratePage> createState() => _CalibratePageState();
}

class _CalibratePageState extends State<CalibratePage> {
  // Page layout constants
  static const double div = 3;
  static const double controlBoxRatio = 1;
  static const double imageBoxRatio = 2;
  static const double boxMargin = 15;

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const SizedBox(width: 15),
        ContainerScaled(
          div,
          controlBoxRatio,
          boxMargin,
          Padding(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ValueListenableBuilder<String>(
                    builder:
                        (BuildContext context, String value, Widget? child) {
                      int currPos = int.parse(value);
                      return Container(
                        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                        decoration: BoxDecoration(
                          color: darkerBlue,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: lightBlue,
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Current position',
                                style: TextStyle(
                                  color: lightBlue,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                currPos.toString(),
                                style: const TextStyle(
                                  color: lightBlue,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    valueListenable: widget.mqtt.cal_pos,
                  ),
                  const SizedBox(height: 15),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      OutlinedTextField(
                        textFieldController,
                        'New value',
                        true,
                      ),
                      OutlinedButtonDark(
                        onSendPressed,
                        'Send',
                        false,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        ContainerScaled(
          div,
          imageBoxRatio,
          boxMargin,
          Padding(
            padding: const EdgeInsets.all(15),
            child: ValueListenableBuilder<String>(
              builder: (BuildContext context, String value, Widget? child) {
                var bytesImage = const Base64Decoder().convert(value);
                return Image.memory(
                  bytesImage,
                );
              },
              valueListenable: widget.mqtt.cal_photo,
            ),
          ),
        ),
      ],
    );
  }
}
