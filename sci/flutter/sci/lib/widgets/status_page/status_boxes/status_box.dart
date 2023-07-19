import "package:flutter/material.dart";
import "package:sci/constants.dart";
import 'package:sci/widgets/status_page/status_boxes/status_container.dart';

import 'package:sci/widgets/status_page/status_boxes/status_tab.dart';

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
  @override
  Widget build(BuildContext context) {
    return StatusContainer(
      Column(
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
