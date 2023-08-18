// ignore: slash_for_doc_comments
/**
 * control_panel.dart
 * 
 * Andreas Holleland
 * 2023
 */

import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../controllers/mqtt_controller.dart';
import '../../controllers/status_controller.dart';
import '../general/container_scaled.dart';
import '../general/outlined_button_dark.dart';
import '../general/outlined_text_field.dart';

class ControlPanel extends StatefulWidget {
  final MQTTController mqtt;

  const ControlPanel(this.mqtt, {super.key});

  @override
  State<ControlPanel> createState() => _ControlPanelState();
}

class _ControlPanelState extends State<ControlPanel> {
  // Text field controller
  TextEditingController sampleInputController = TextEditingController();

  void resetButtonPressed() {}

  void sampleButtonPressed() {
    widget.mqtt.publishMessage(topics.CTRL_SAMPLE, sampleInputController.text);
    sampleInputController.clear();
  }

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
    widget.mqtt.image.value = '0';
    widget.mqtt.publishMessage(topics.CTRL_IMAGE, '1');
  }

  void stopPumpButtonPressed() {
    widget.mqtt.publishMessage(topics.CTRL_STOP, '1');
  }

  void samplePumpButtonPressed() {
    widget.mqtt.publishMessage(topics.CTRL_SAMPLE_PUMP, '1');
  }

  Color setTitleColor(bool value) {
    if (value) {
      return lightBlue;
    }
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return ContainerScaled(
      div,
      leftRatio,
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
                  sampleInputController, 'N Samples', !manualSampling),

              // Start sampling button
              const SizedBox(height: buttonSpacing),
              OutlinedButtonDark(sampleButtonPressed, 'Start', !manualSampling),

              // Reset Button
              const SizedBox(height: buttonSpacing),
              OutlinedButtonDark(resetButtonPressed, 'Reset', !manualSampling),

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
    );
  }
}
