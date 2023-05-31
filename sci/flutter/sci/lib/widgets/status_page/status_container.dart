import 'package:flutter/material.dart';

import 'package:sci/constants.dart';

class StatusContainer extends StatelessWidget {
  const StatusContainer({super.key});

  static const double xMax = 300;
  static const double yMax = 350;
  static const double xMin = 300;
  static const double yMin = 350;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      decoration: BoxDecoration(
        color: darkBlue,
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
        maxWidth: xMax,
        maxHeight: yMax,
        minWidth: xMin,
        minHeight: yMin,
      ),
    );
  }
}
