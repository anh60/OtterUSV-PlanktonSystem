// ignore: slash_for_doc_comments
/**
 * container_scaled.dart
 * 
 * Andreas Holleland
 * 2023
 */

import 'package:flutter/material.dart';

import 'package:sci/constants.dart';

class ContainerScaled extends StatelessWidget {
  final double div; // Divisor for horizontal scaling
  final double ratio; // Ratio of container with respect to divisor
  final double margin; // x margin
  final Widget child; // Content within conntainer

  const ContainerScaled(this.div, this.ratio, this.margin, this.child,
      {super.key});

  static const int sideBarSize = 40;

  double getAvailableWidth(BuildContext context) {
    return ((((MediaQuery.of(context).size.width) / div) * ratio) -
        sideBarSize -
        (margin / 2));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: getAvailableWidth(context),
      margin: const EdgeInsets.fromLTRB(0, 15, 0, 15),
      decoration: BoxDecoration(
        color: darkBlue,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(1),
            spreadRadius: 3,
            blurRadius: 9,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}
