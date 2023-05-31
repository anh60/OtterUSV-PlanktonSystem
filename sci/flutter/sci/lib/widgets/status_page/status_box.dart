import "package:flutter/material.dart";
import "package:sci/constants.dart";

import "package:sci/widgets/status_page/status_tab.dart";

class StatusBox extends StatefulWidget {
  final String label;
  final List<String> labels;
  final int flags;

  const StatusBox(
    this.label,
    this.labels,
    this.flags,
  );

  @override
  State<StatusBox> createState() => _StatusBoxState();
}

class _StatusBoxState extends State<StatusBox> {
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

      // Column for all the status flags
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            widget.label,
            style: const TextStyle(
              color: lightBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          StatusTab(widget.labels[0], (widget.flags >> 0) & 1),
          StatusTab(widget.labels[1], (widget.flags >> 1) & 1),
          StatusTab(widget.labels[2], (widget.flags >> 2) & 1),
          StatusTab(widget.labels[3], (widget.flags >> 3) & 1),
          StatusTab(widget.labels[4], (widget.flags >> 4) & 1),
          StatusTab(widget.labels[5], (widget.flags >> 5) & 1),
          StatusTab(widget.labels[6], (widget.flags >> 6) & 1),
          StatusTab(widget.labels[7], (widget.flags >> 7) & 1),
        ],
      ),
    );
  }
}
