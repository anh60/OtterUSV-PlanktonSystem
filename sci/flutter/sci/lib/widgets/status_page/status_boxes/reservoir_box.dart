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
  final valveFieldCOntroller = TextEditingController();

  @override
  void dispose() {
    pumpFieldController.dispose();
    valveFieldCOntroller.dispose();
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
              color: lightBlue,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Vertical gap
          const SizedBox(height: 15),

          // Current fill time
          const StatusTab('Fill time', 1000),

          // Vertical gap
          const SizedBox(height: 5),

          // Current flush time
          const StatusTab('Flush time', 1000),

          // Vertical gap
          const SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedTextField(pumpFieldController, 'Fill time', true),
              OutlinedButtonDark(() => null, 'Send', false),
            ],
          ),

          // Vertical gap
          const SizedBox(height: 5),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedTextField(valveFieldCOntroller, 'Flush time', true),
              OutlinedButtonDark(() => null, 'Send', false),
            ],
          ),
        ],
      ),
    );
  }
}
