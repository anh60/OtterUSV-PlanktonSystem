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
  // Text field controllers
  TextEditingController sampleInputController = TextEditingController();
  TextEditingController latInputController = TextEditingController();
  TextEditingController lonInputController = TextEditingController();

  void resetButtonPressed() {}

  void sendPosButton() {
    widget.mqtt.pubRetainedMessage(topics.VEHICLE_POS,
        ('${latInputController.text},${lonInputController.text}'));
    latInputController.clear();
    lonInputController.clear();
  }

  void sampleButton() {
    widget.mqtt.publishMessage(topics.CTRL_SAMPLE, sampleInputController.text);
    sampleInputController.clear();
  }

  void rmsFillButton() {
    widget.mqtt.publishMessage(topics.CTRL_RMS_PUMP, '1');
  }

  void rmsFlushButton() {
    widget.mqtt.publishMessage(topics.CTRL_RMS_VALVE, '1');
  }

  void rmsStopButton() {
    widget.mqtt.publishMessage(topics.CTRL_RMS_STOP, '1');
  }

  void startPumpButton() {
    widget.mqtt.publishMessage(topics.CTRL_SAMPLE_PUMP, '1');
  }

  void stopPumpButton() {
    widget.mqtt.publishMessage(topics.CTRL_SAMPLE_PUMP, '0');
  }

  void cameraButton() {
    widget.mqtt.image.value = '0';
    widget.mqtt.publishMessage(topics.CTRL_IMAGE, '1');
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

              // Latitude text field
              const SizedBox(height: buttonSpacing),
              OutlinedTextField(
                  latInputController, 'Latitude', !manualSampling),

              // Longitude text field
              const SizedBox(height: buttonSpacing),
              OutlinedTextField(
                  lonInputController, 'Longitude', !manualSampling),

              // Reset Button
              const SizedBox(height: buttonSpacing),
              OutlinedButtonDark(sendPosButton, 'Send', !manualSampling),

              const SizedBox(height: buttonSpacing),

              // N-Samples text field
              const SizedBox(height: buttonSpacing),
              OutlinedTextField(
                  sampleInputController, 'N Samples', !manualSampling),

              // Start sampling button
              const SizedBox(height: buttonSpacing),
              OutlinedButtonDark(sampleButton, 'Start', !manualSampling),

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
                rmsFillButton,
                'Fill',
                !manualControl,
              ),

              // Flush reservoir button
              const SizedBox(height: buttonSpacing),
              OutlinedButtonDark(
                rmsFlushButton,
                'Flush',
                !manualControl,
              ),

              // Stop button (rms idle)
              const SizedBox(height: buttonSpacing),
              OutlinedButtonDark(
                rmsStopButton,
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
                startPumpButton,
                'Pump',
                !manualControl,
              ),

              // P-scope camera button
              const SizedBox(height: buttonSpacing),
              OutlinedButtonDark(
                cameraButton,
                'Camera',
                !manualControl,
              ),

              // P-scope stop button
              const SizedBox(height: buttonSpacing),
              OutlinedButtonDark(
                stopPumpButton,
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
