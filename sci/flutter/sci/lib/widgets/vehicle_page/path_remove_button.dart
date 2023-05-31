import 'package:flutter/material.dart';

import 'package:sci/constants.dart';

class PathRemoveButton extends StatelessWidget {
  final Function(int index) onButtonPress;
  final int index;

  const PathRemoveButton(this.onButtonPress, this.index, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25,
      width: 25,
      child: FloatingActionButton.extended(
        label: const Text(
          'X',
          style: TextStyle(
            color: lightBlue,
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

        // When pressed
        onPressed: () {
          onButtonPress(index);
        },
      ),
    );
  }
}
