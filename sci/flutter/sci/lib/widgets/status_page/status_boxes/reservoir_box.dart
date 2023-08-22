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
    return const StatusContainer(
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // Vertical gap
          SizedBox(height: 5),

          // Label
          Text(
            'RESERVOIR',
            style: TextStyle(
              fontSize: 12.5,
              color: lightBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
