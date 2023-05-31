import 'package:flutter/material.dart';

import 'package:sci/constants.dart';

class OutlinedButtonDark extends StatelessWidget {
  final Function() onButtonPress;
  final String label;

  const OutlinedButtonDark(this.onButtonPress, this.label, {super.key});

  @override
  Widget build(BuildContext context) {
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
          style: const TextStyle(
            color: Color.fromARGB(255, 169, 216, 255),
            fontSize: 15,
          ),
        ),
        backgroundColor: darkerBlue,
        elevation: 5,
        hoverColor: darkBlue,
        hoverElevation: 10,
        splashColor: Colors.blue,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: lightBlue),
          borderRadius: BorderRadius.circular(5),
        ),
        onPressed: () {
          onButtonPress();
        },
      ),
    );
  }
}
