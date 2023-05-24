import "package:flutter/material.dart";

import "package:sci/widgets/status_tab.dart";

class StatusBox extends StatefulWidget {
  String name0, name1, name2, name3, name4, name5, name6, name7;
  int val0, val1, val2, val3, val4, val5, val6, val7;

  StatusBox(
    this.name0,
    this.val0,
    this.name1,
    this.val1,
    this.name2,
    this.val2,
    this.name3,
    this.val3,
    this.name4,
    this.val4,
    this.name5,
    this.val5,
    this.name6,
    this.val6,
    this.name7,
    this.val7,
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
          StatusTab(widget.name0, widget.val0),
          StatusTab(widget.name1, widget.val1),
          StatusTab(widget.name2, widget.val2),
          StatusTab(widget.name3, widget.val3),
          StatusTab(widget.name4, widget.val4),
          StatusTab(widget.name5, widget.val5),
          StatusTab(widget.name6, widget.val6),
          StatusTab(widget.name7, widget.val7),
        ],
      ),
    );
  }
}
