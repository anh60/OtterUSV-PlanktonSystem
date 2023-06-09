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

  void stopPumpButtonPressed() {
    widget.mqtt.publishMessage(topics.CTRL_STOP, '1');
  }

  void samplePumpButtonPressed() {
    widget.mqtt.publishMessage(topics.CTRL_SAMPLE_PUMP, '1');
  }

  void buttonPlaceholder() {}

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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  const SizedBox(height: buttonSpacing),
                  OutlinedTextField(
                      textFieldController, 'N Samples', manualSampling),
                  const SizedBox(height: buttonSpacing),
                  OutlinedButtonDark(
                      sampleButtonPressed, 'Start', !manualSampling),
                  const SizedBox(height: buttonSpacing),
                  OutlinedButtonDark(
                      resetButtonPressed, 'Reset', !manualSampling),
                  const SizedBox(height: buttonSpacing),
                  Switch(
                    value: manualControl,
                    onChanged: (bool value) {
                      setState(() {
                        manualControl = value;
                      });
                    },
                    activeColor: lightBlue,
                  ),
                  const SizedBox(height: buttonSpacing),
                  OutlinedButtonDark(
                    pumpButtonPressed,
                    '12V Pump',
                    !manualControl,
                  ),
                  const SizedBox(height: buttonSpacing),
                  OutlinedButtonDark(
                    valveButtonPressed,
                    'Valve',
                    !manualControl,
                  ),
                  const SizedBox(height: buttonSpacing),
                  OutlinedButtonDark(
                    stopButtonPressed,
                    'Stop',
                    !manualControl,
                  ),
                  const SizedBox(height: buttonSpacing),
                  OutlinedButtonDark(
                    littlePumpButtonPressed,
                    '5V Pump',
                    !manualControl,
                  ),
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
            child: Container(
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
                    builder:
                        (BuildContext context, String value, Widget? child) {
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
                    builder:
                        (BuildContext context, String value, Widget? child) {
                      status.setStatus(value);
                      return StatusBox(
                        status.rms.label,
                        status.rms.flagLabels,
                        status.rms.flags,
                      );
                    },
                  ),
                  const SizedBox(width: 15),
                  StatusContainer(Placeholder()),
                  const SizedBox(width: 15),
                  StatusContainer(Placeholder()),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
