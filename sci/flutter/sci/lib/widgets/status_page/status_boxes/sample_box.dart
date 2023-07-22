// ignore: slash_for_doc_comments
/**
 * sample_box.dart
 * 
 * Andreas Holleland
 * 2023
 */

import "package:flutter/material.dart";
import "package:sci/constants.dart";
import 'package:sci/widgets/status_page/status_boxes/status_container.dart';

class SampleBox extends StatefulWidget {
  const SampleBox({super.key});

  @override
  State<SampleBox> createState() => _SampleBoxState();
}

class _SampleBoxState extends State<SampleBox> {
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
            'SAMPLE',
            style: TextStyle(
              color: lightBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
