// ignore: slash_for_doc_comments
/**
 * reservoir_box.dart
 * 
 * Andreas Holleland
 * 2023
 */

import "package:flutter/material.dart";
import "package:sci/constants.dart";
import 'package:sci/widgets/general/outlined_button_dark.dart';
import 'package:sci/widgets/status_page/status_boxes/status_container.dart';
import 'package:sci/widgets/status_page/status_boxes/status_tab.dart';

import '../../general/outlined_text_field.dart';

class ReservoirBox extends StatefulWidget {
  const ReservoirBox({super.key});

  @override
  State<ReservoirBox> createState() => _ReservoirBoxState();
}

class _ReservoirBoxState extends State<ReservoirBox> {
  final pumpFieldController = TextEditingController();
  final valveFieldController = TextEditingController();
  final depthFieldCondtroller = TextEditingController();

  @override
  void dispose() {
    pumpFieldController.dispose();
    valveFieldController.dispose();
    depthFieldCondtroller.dispose();
    super.dispose();
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
            'RESERVOIR',
            style: TextStyle(
              fontSize: 12.5,
              color: lightBlue,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Vertical gap
          const SizedBox(height: 15),

          // Current fill time
          const StatusTab('Fill time', 5000),

          // Vertical gap
          const SizedBox(height: 5),

          // Current flush time
          const StatusTab('Flush time', 5000),

          // Vertical gap
          const SizedBox(height: 5),

          // Current flush time
          const StatusTab('Depth', 50),

          // Vertical gap
          const SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedTextField(pumpFieldController, 'Fill time', false),
              OutlinedButtonDark(() => null, 'Send', false),
            ],
          ),

          // Vertical gap
          const SizedBox(height: 5),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedTextField(valveFieldController, 'Flush time', false),
              OutlinedButtonDark(() => null, 'Send', false),
            ],
          ),
        ],
      ),
    );
  }
}
