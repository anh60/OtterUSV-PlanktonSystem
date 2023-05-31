import 'package:flutter/material.dart';

import 'package:sci/constants.dart';

class PathMarkerTab extends StatelessWidget {
  final int index;

  const PathMarkerTab(this.index, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 300),
      alignment: Alignment.center,
      margin: const EdgeInsets.fromLTRB(25, 5, 25, 5),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: darkerBlue,
        shape: BoxShape.rectangle,
        border: Border.all(
          color: lightBlue,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Point: ${index + 1}',
            style: const TextStyle(
              color: lightBlue,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
