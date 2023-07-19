import 'package:flutter/material.dart';

import 'package:sci/constants.dart';

class StatusContainer extends StatelessWidget {
  final Widget child;

  const StatusContainer(this.child, {super.key});

  static const double xMax = 300;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
      decoration: BoxDecoration(
        color: darkBlue,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(5),
      ),
      constraints: const BoxConstraints(
        maxWidth: xMax,
      ),
      child: child,
    );
  }
}
