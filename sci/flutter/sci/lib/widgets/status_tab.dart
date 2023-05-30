import "package:flutter/material.dart";

import "package:sci/constants.dart";

class StatusTab extends StatefulWidget {
  String name;
  int value;

  StatusTab(this.name, this.value);

  @override
  State<StatusTab> createState() => _StatusTabState();
}

class _StatusTabState extends State<StatusTab> {
  static const double fontsize = 15;
  static const double radius = 10;
  static const double xMargin = 10;
  static const double yMargin = 5;
  static const double xPadding = 10;
  static const double yPadding = 5;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.fromLTRB(xMargin, yMargin, xMargin, yMargin),
      padding:
          const EdgeInsets.fromLTRB(xPadding, yPadding, xPadding, yPadding),
      decoration: BoxDecoration(
        color: darkerBlue,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              widget.name,
              style: const TextStyle(
                color: lightBlue,
                fontSize: fontsize,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              widget.value.toString(),
              style: const TextStyle(
                color: lightBlue,
                fontSize: fontsize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
