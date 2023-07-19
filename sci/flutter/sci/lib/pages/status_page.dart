import "package:flutter/material.dart";

import "package:sci/controllers/status_controller.dart";
import "package:sci/controllers/mqtt_controller.dart";
import 'package:sci/widgets/general/microscope_image.dart';
import 'package:sci/widgets/status_page/control_panel.dart';
import 'package:sci/widgets/status_page/status_boxes.dart';

// Constructor
class StatusPage extends StatefulWidget {
  final MQTTController mqtt;
  const StatusPage(this.mqtt, {super.key});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

// Stateful widget
class _StatusPageState extends State<StatusPage> {
  // Controller for this page
  StatusController status = StatusController();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Empty gap
        const SizedBox(width: 15),

        // Control panel (left)
        ControlPanel(widget.mqtt),

        // Empty gap
        const SizedBox(width: 15),

        // Status boxes and image (right)
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              StatusBoxes(status, widget.mqtt),
              MicroscopeImage(widget.mqtt.image, div, rightRatio),
            ],
          ),
        ),
      ],
    );
  }
}
