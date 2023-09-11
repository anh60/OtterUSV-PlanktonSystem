// ignore: slash_for_doc_comments
/**
 * status_page.dart
 * 
 * Andreas Holleland
 * 2023
 */

//---------------------------- PACKAGES ----------------------------------------

import "package:flutter/material.dart";
import "package:sci/controllers/status_controller.dart";
import "package:sci/controllers/mqtt_controller.dart";
import 'package:sci/widgets/general/microscope_image.dart';
import 'package:sci/widgets/status_page/control_panel.dart';
import 'package:sci/widgets/status_page/status_boxes.dart';

//---------------------------- WIDGET ------------------------------------------

class StatusPage extends StatefulWidget {
  final MQTTController mqtt;
  const StatusPage(this.mqtt, {super.key});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

//---------------------------- STATE -------------------------------------------

class _StatusPageState extends State<StatusPage> {
  //---------------------------- INIT ------------------------------------------

  StatusController status = StatusController();

  //---------------------------- BUILD WIDGET ----------------------------------

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Empty gap
        const SizedBox(width: 15),

        // Control panel (left)
        ControlPanel(widget.mqtt, status),

        // Empty gap
        const SizedBox(width: 15),

        // Scrollable column
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          clipBehavior: Clip.none,
          child: Column(
            children: [
              // Empty gap
              const SizedBox(height: 15),

              // Status boxes
              StatusBoxes(status, widget.mqtt),

              // Empty gap
              const SizedBox(height: 15),

              // Image
              MicroscopeImage(widget.mqtt.image, div, rightRatio),

              // Empty gap
              const SizedBox(height: 15),

              /*
              ValueListenableBuilder<List<bool>>(
                valueListenable: status.statusMapToggle,
                builder:
                    (BuildContext context, List<bool> value, Widget? child) {
                  return Text(value[0].toString() + value[1].toString());
                },
              ),
              */
            ],
          ),
        ),
      ],
    );
  }
}
