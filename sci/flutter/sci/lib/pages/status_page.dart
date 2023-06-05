import "package:flutter/material.dart";

import "package:sci/constants.dart";
import "package:sci/controllers/status_controller.dart";
import "package:sci/controllers/mqtt_controller.dart";
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

  void samplePumpButtonPressed() {
    widget.mqtt.publishMessage(topics.CTRL_SAMPLE_PUMP, '1');
  }

  void buttonPlaceholder() {}

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          // Status boxes
          ValueListenableBuilder<String>(
            builder: (BuildContext context, String value, Widget? child) {
              status.setStatus(value);
              return SizedBox(
                height: 400,
                width: 1320,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    StatusBox(status.pscope.label, status.pscope.flagLabels,
                        status.pscope.flags),
                    StatusBox(status.rms.label, status.rms.flagLabels,
                        status.rms.flags),
                    StatusContainer(),
                    StatusContainer(),
                  ],
                ),
              );
            },
            valueListenable: widget.mqtt.status_flags,
          ),

          // Bottom boxes
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Bottom left box
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 77, 90, 114),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueGrey.withOpacity(1),
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                constraints: const BoxConstraints(
                  maxWidth: 630,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Switch(
                          value: manualSampling,
                          onChanged: (bool value) {
                            setState(() {
                              manualSampling = value;
                            });
                          },
                          activeColor: lightBlue,
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        OutlinedTextField(
                            textFieldController, 'N Samples', manualSampling),
                        const SizedBox(width: 15),
                        OutlinedButtonDark(
                            sampleButtonPressed, 'Start', !manualSampling),
                        const SizedBox(width: 15),
                        OutlinedButtonDark(
                            resetButtonPressed, 'Reset', !manualSampling)
                      ],
                    ),
                  ],
                ),
              ),

              // Bottom right box
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 77, 90, 114),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueGrey.withOpacity(1),
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                constraints: const BoxConstraints(
                  maxWidth: 630,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Switch(
                          value: manualControl,
                          onChanged: (bool value) {
                            setState(() {
                              manualControl = value;
                            });
                          },
                          activeColor: lightBlue,
                        ),
                      ],
                    ),
                    OutlinedButtonDark(
                      pumpButtonPressed,
                      '12V Pump',
                      !manualControl,
                    ),
                    OutlinedButtonDark(
                      valveButtonPressed,
                      'Valve',
                      !manualControl,
                    ),
                    OutlinedButtonDark(
                      stopButtonPressed,
                      'Stop',
                      !manualControl,
                    ),
                    OutlinedButtonDark(
                      samplePumpButtonPressed,
                      '5V Pump',
                      !manualControl,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
