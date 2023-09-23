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
  final Widget child; // Content within container

  const ContainerScaled(this.div, this.ratio, this.margin, this.child,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: getAvailableWidth(context, div, ratio),
      margin: const EdgeInsets.only(top: containerGap, bottom: containerGap),
      decoration: BoxDecoration(
        color: darkBlue,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(rSmall),
        boxShadow: [containerShadow],
      ),
      child: child,
    );
  }
}
