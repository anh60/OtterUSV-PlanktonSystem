// Page layout constants
import 'package:flutter/material.dart';

const double div = 3;
const double leftRatio = 1;
const double rightRatio = 2;
const double boxMargin = 15;

// String printed when loading images
const String loading = 'Loading';

class ImageController extends StatefulWidget {
  const ImageController({super.key});

  @override
  State<ImageController> createState() => _ImageControllerState();

  List<bool> getToggleButtonState() {
    return getToggleButtonState();
  }
}

class _ImageControllerState extends State<ImageController> {
  List<bool> toggleButtonState = [true, false];

  List<bool> getToggleButtonState() {
    return toggleButtonState;
  }

  void setToggleButtonState(List<bool> state) {
    setState(() {
      toggleButtonState = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
/*
class ImageController {
  List<bool> toggleButtonState = [true, false];

  List<bool> getToggleButtonState() {
    return toggleButtonState;
  }
}
*/