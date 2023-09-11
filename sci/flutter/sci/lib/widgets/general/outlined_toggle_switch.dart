import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../controllers/image_controller.dart';

class OutlinedToggleSwitch extends StatefulWidget {
  List<bool> state;
  OutlinedToggleSwitch(this.state, {super.key});

  @override
  State<OutlinedToggleSwitch> createState() => _OutlinedToggleSwitchState();
}

class _OutlinedToggleSwitchState extends State<OutlinedToggleSwitch> {
  late List<bool> toggleButtonState = widget.state;

  List<bool> getToggleButtonState() {
    return toggleButtonState;
  }

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      direction: Axis.vertical,
      isSelected: toggleButtonState,
      onPressed: (int index) {
        for (int i = 0; i < toggleButtonState.length; i++) {
          if (i == index) {
            toggleButtonState[i] = true;
          } else {
            toggleButtonState[i] = false;
          }
        }
        setState(() {});
      },

      // Colors
      borderColor: lightBlue,
      selectedColor: lightBlue,
      color: darkerBlue,
      fillColor: darkerBlue,
      splashColor: Colors.blue,
      selectedBorderColor: lightBlue,
      hoverColor: const Color.fromARGB(92, 144, 220, 255),

      // Border
      renderBorder: true,
      borderWidth: 1,
      borderRadius: BorderRadius.circular(10),

      // Content
      children: const [
        SizedBox(
          height: 75,
          width: 75,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //Text('Image'),
              Icon(
                Icons.image,
                size: 25,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 75,
          width: 75,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //Text('Map'),
              Icon(
                Icons.map,
                size: 25,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
