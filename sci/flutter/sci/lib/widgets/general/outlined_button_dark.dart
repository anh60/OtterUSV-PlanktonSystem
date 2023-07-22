// ignore: slash_for_doc_comments
/**
 * outlined_button_dark.dart
 * 
 * Andreas Holleland
 * 2023
 */

import 'package:flutter/material.dart';
import 'package:sci/constants.dart';

class OutlinedButtonDark extends StatelessWidget {
  final Function() onButtonPress;
  final String label;
  final bool notActive;

  const OutlinedButtonDark(this.onButtonPress, this.label, this.notActive,
      {super.key});

  @override
  Widget build(BuildContext context) {
    Color textColor;
    Color outlineColor;
    double elevation;

    if (notActive) {
      textColor = Colors.grey;
      outlineColor = const Color.fromARGB(62, 0, 0, 0);
      elevation = 0;
    } else {
      textColor = lightBlue;
      outlineColor = lightBlue;
      elevation = 5;
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      constraints: const BoxConstraints(
        minWidth: 100,
        maxWidth: 100,
        minHeight: 50,
        maxHeight: 50,
      ),
      child: FloatingActionButton.extended(
        label: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 15,
          ),
        ),
        backgroundColor: darkerBlue,
        elevation: elevation,
        hoverColor: darkBlue,
        hoverElevation: 10,
        splashColor: Colors.blue,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: outlineColor),
          borderRadius: BorderRadius.circular(5),
        ),
        onPressed: notActive ? null : onButtonPress,
      ),
    );
  }
}
