import 'dart:async';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import 'package:sci/constants.dart';

import 'package:sci/widgets/vehicle_page/path_marker_tab.dart';
import 'package:sci/widgets/vehicle_page/path_remove_button.dart';

class PathListWindow extends StatefulWidget {
  final List<LatLng> markerList;
  final Function() buildMarkers;

  const PathListWindow(this.markerList, this.buildMarkers, {super.key});

  @override
  State<PathListWindow> createState() => _PathListWindowState();
}

class _PathListWindowState extends State<PathListWindow> {
  void removeButtonPressed(int index) {
    setState(() {
      widget.markerList.removeAt(index);
      widget.buildMarkers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.fromLTRB(25, 5, 25, 5),
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        decoration: BoxDecoration(
          color: darkBlue,
          shape: BoxShape.rectangle,
          border: Border.all(
            color: lightBlue,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: ListView.builder(
          itemCount: widget.markerList.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return Row(
              children: [
                PathMarkerTab(index),
                PathRemoveButton(removeButtonPressed, index),
              ],
            );
          },
        ),
      ),
    );
  }
}
