import "package:flutter/material.dart";

import "package:sci/widgets/status_tab.dart";

class StatusBox extends StatefulWidget {
  List<String> labels;
  int flags;

  StatusBox(
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
        color: Colors.blueGrey,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
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
