import "dart:convert";

import "package:flutter/material.dart";

import "package:sci/constants.dart";
import "package:sci/controllers/status_controller.dart";
import "package:sci/controllers/mqtt_controller.dart";
import "package:sci/widgets/container_scaled.dart";
import "package:sci/widgets/outlined_button_dark.dart";
import "package:sci/widgets/outlined_text_field.dart";
import "package:sci/widgets/status_page/calibration_box.dart";
import "package:sci/widgets/status_page/reservoir_box.dart";
import "package:sci/widgets/status_page/status_box.dart";

class StatusPage extends StatefulWidget {
  final MQTTController mqtt;
  const StatusPage(this.mqtt, {super.key});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  // Page layout constants
  static const double div = 4;
  static const double controlBoxRatio = 1;
  static const double statusFieldRatio = 3;
  static const double boxMargin = 15;

  static const double buttonSpacing = 10;

  StatusController status = StatusController();

  TextEditingController textFieldController = TextEditingController();

  bool manualSampling = false;
  bool manualControl = false;

  void sampleButtonPressed() {
    widget.mqtt.publishMessage(topics.CTRL_SAMPLE, textFieldController.text);
    textFieldController.clear();
  }

  void resetButtonPressed() {}

  void pumpButtonPressed() {
    widget.mqtt.publishMessage(topics.CTRL_RMS_PUMP, '1');
  }

  void valveButtonPressed() {
    widget.mqtt.publishMessage(topics.CTRL_RMS_VALVE, '1');
  }

  void stopButtonPressed() {
    widget.mqtt.publishMessage(topics.CTRL_RMS_STOP, '1');
  }

  void littlePumpButtonPressed() {
    widget.mqtt.publishMessage(topics.CTRL_SAMPLE_PUMP, '1');
  }

  void cameraButtonPressed() {
    widget.mqtt.publishMessage(topics.CTRL_IMAGE, '1');
  }

  void stopPumpButtonPressed() {
    widget.mqtt.publishMessage(topics.CTRL_STOP, '1');
  }

  void samplePumpButtonPressed() {
    widget.mqtt.publishMessage(topics.CTRL_SAMPLE_PUMP, '1');
  }

  void buttonPlaceholder() {}

  Color setTitleColor(bool value) {
    if (value) {
      return lightBlue;
    }
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Horizontal gap
        const SizedBox(width: 15),

        // Control panel (left)
        ContainerScaled(
          div,
          controlBoxRatio,
          boxMargin,
          Padding(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Switch(
                    value: manualSampling,
                    onChanged: (bool value) {
                      setState(() {
                        manualSampling = value;
                      });
                    },
                    activeColor: lightBlue,
                  ),

                  // Title over buttons
                  Text(
                    'Sample',
                    style: TextStyle(
                      color: setTitleColor(manualSampling),
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(
                      maxHeight: 1,
                    ),
                    color: setTitleColor(manualSampling),
                  ),

                  // N-Samples text field
                  const SizedBox(height: buttonSpacing),
                  OutlinedTextField(
                      textFieldController, 'N Samples', manualSampling),

                  // Start sampling button
                  const SizedBox(height: buttonSpacing),
                  OutlinedButtonDark(
                      sampleButtonPressed, 'Start', !manualSampling),

                  // Reset Button
                  const SizedBox(height: buttonSpacing),
                  OutlinedButtonDark(
                      resetButtonPressed, 'Reset', !manualSampling),

                  // Manual control switch
                  const SizedBox(height: 20),
                  Switch(
                    value: manualControl,
                    onChanged: (bool value) {
                      setState(() {
                        manualControl = value;
                      });
                    },
                    activeColor: lightBlue,
                  ),

                  // Title over buttons
                  Text(
                    'RMS',
                    style: TextStyle(
                      color: setTitleColor(manualControl),
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(
                      maxHeight: 1,
                    ),
                    color: setTitleColor(manualControl),
                  ),

                  // Fill reservoir button
                  const SizedBox(height: buttonSpacing),
                  OutlinedButtonDark(
                    pumpButtonPressed,
                    'Fill',
                    !manualControl,
                  ),

                  // Flush reservoir button
                  const SizedBox(height: buttonSpacing),
                  OutlinedButtonDark(
                    valveButtonPressed,
                    'Flush',
                    !manualControl,
                  ),

                  // Stop button (rms idle)
                  const SizedBox(height: buttonSpacing),
                  OutlinedButtonDark(
                    stopButtonPressed,
                    'Stop',
                    !manualControl,
                  ),

                  // Title over buttons
                  const SizedBox(height: 20),
                  Text(
                    'PIS',
                    style: TextStyle(
                      color: setTitleColor(manualControl),
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(
                      maxHeight: 1,
                    ),
                    color: setTitleColor(manualControl),
                  ),

                  // P-scope pump button
                  const SizedBox(height: buttonSpacing),
                  OutlinedButtonDark(
                    littlePumpButtonPressed,
                    'Pump',
                    !manualControl,
                  ),

                  // P-scope camera button
                  const SizedBox(height: buttonSpacing),
                  OutlinedButtonDark(
                    cameraButtonPressed,
                    'Camera',
                    !manualControl,
                  ),

                  // P-scope stop button
                  const SizedBox(height: buttonSpacing),
                  OutlinedButtonDark(
                    stopPumpButtonPressed,
                    'Stop',
                    !manualControl,
                  ),
                ],
              ),
            ),
          ),
        ),

        // Horizontal gap
        const SizedBox(width: 15),

        // Status boxes and image (right)
        Align(
          alignment: Alignment.topCenter,

          // Vertical scroll
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,

            // Scrollable column
            child: Column(
              children: [
                // Status boxes
                Container(
                  // Configuration
                  margin: const EdgeInsets.only(top: 15),
                  constraints: const BoxConstraints(
                    maxHeight: 325,
                  ),
                  width: ((((MediaQuery.of(context).size.width) / div) *
                          statusFieldRatio) -
                      (40) -
                      (15 / 2)),

                  // Horizontal scroll
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      // PIS container
                      ValueListenableBuilder<String>(
                        valueListenable: widget.mqtt.status_flags,
                        builder: (BuildContext context, String value,
                            Widget? child) {
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
                        valueListenable: widget.mqtt.status_flags,
                        builder: (BuildContext context, String value,
                            Widget? child) {
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

                      // Calibration/microscopev box
                      CalibrationBox(widget.mqtt),

                      // Horizontal gap
                      const SizedBox(width: 15),

                      // Empty Status container
                      ReservoirBox(),
                    ],
                  ),
                ),

                // Microscope image
                Container(
                  // Config
                  padding: const EdgeInsets.all(0),
                  margin: const EdgeInsets.only(top: 15, bottom: 15),
                  width: ((((MediaQuery.of(context).size.width) / div) *
                          statusFieldRatio) -
                      (40) -
                      (15 / 2)),
                  decoration: BoxDecoration(
                    color: darkBlue,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  alignment: Alignment.topCenter,

                  // Image
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: ValueListenableBuilder<String>(
                      // Listen to image value received over mqtt
                      valueListenable: widget.mqtt.image,

                      // Build and display image
                      builder:
                          (BuildContext context, String value, Widget? child) {
                        // If no image is transmitted, return placeholder
                        if (value == '0') {
                          return Image.asset('lib/image.jpg');
                        }

                        // Append n "=" if size is not multiple of four
                        else {
                          if (value.length % 4 > 0) {
                            value += '=' * (4 - value.length % 4);
                          }

                          // Convert Base64 String to Image object
                          var bytesImage = const Base64Decoder().convert(value);
                          return Image.memory(bytesImage);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
