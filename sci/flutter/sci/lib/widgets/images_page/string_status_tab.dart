// ignore: slash_for_doc_comments
/**
 * string_status_tab.dart
 * 
 * Andreas Holleland
 * 2023
 */

import "package:flutter/material.dart";
import "package:sci/constants.dart";

class StringStatusTab extends StatefulWidget {
  final String name;
  final String value;

  const StringStatusTab(this.name, this.value, {super.key});

  @override
  State<StringStatusTab> createState() => _StringStatusTabState();
}

class _StringStatusTabState extends State<StringStatusTab> {
  static const double fontsize = 15;
  static const double radius = 10;
  static const double xPadding = 10;
  static const double yPadding = 5;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
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
