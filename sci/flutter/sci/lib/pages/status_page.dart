import "package:flutter/material.dart";

import "package:sci/constants.dart";
import "package:sci/controllers/status_controller.dart";
import "package:sci/controllers/mqtt_controller.dart";
import "package:sci/widgets/container_scaled.dart";
import "package:sci/widgets/outlined_button_dark.dart";
import "package:sci/widgets/outlined_text_field.dart";
import "package:sci/widgets/status_page/status_box.dart";
import "package:sci/widgets/status_page/status_container.dart";

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
    widget.mqtt.publishMessage(topics.CTRL_SAMPLE, '1');
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

  void cameraButtonPressed() {}

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
        const SizedBox(width: 15),
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
        const SizedBox(width: 15),
        Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 15),
                  constraints: const BoxConstraints(
                    maxHeight: 325,
                  ),
                  width: ((((MediaQuery.of(context).size.width) / div) *
                          statusFieldRatio) -
                      (40) -
                      (15 / 2)),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
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
                      const SizedBox(width: 15),
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
                      const SizedBox(width: 15),
                      const StatusContainer(Placeholder()),
                      const SizedBox(width: 15),
                      const StatusContainer(Placeholder()),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.only(top: 15, bottom: 15),
                  //height: ((MediaQuery.of(context).size.height)),
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
                  child: Image.asset('lib/image.jpg'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
