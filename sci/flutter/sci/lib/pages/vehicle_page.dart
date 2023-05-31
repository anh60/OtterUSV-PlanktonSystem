import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:sci/constants.dart';
import 'package:sci/widgets/outlined_button_dark.dart';
import 'package:sci/widgets/outlined_text_field.dart';
import 'package:sci/widgets/vehicle_page/path_list_window.dart';
import 'package:sci/widgets/vehicle_page/path_marker_tab.dart';
import 'package:sci/widgets/vehicle_page/path_remove_button.dart';

class VehiclePage extends StatefulWidget {
  const VehiclePage({super.key});

  @override
  State<VehiclePage> createState() => _VehiclePageState();
}

class _VehiclePageState extends State<VehiclePage> {
  // Controllers for text fields
  final latFieldController = TextEditingController();
  final lonFieldController = TextEditingController();

  // Dispose text field controllers
  @override
  void dispose() {
    latFieldController.dispose();
    lonFieldController.dispose();
    super.dispose();
  }

  // List of markers
  List<LatLng> markerList = [];
  List<Marker> markers = [];

  void addButtonPressed() {
    if (latFieldController.text.isNotEmpty &&
        lonFieldController.text.isNotEmpty) {
      double lat = double.parse(latFieldController.text);
      double lon = double.parse(lonFieldController.text);

      setState(() {
        markerList.add(LatLng(lat, lon));
        latFieldController.clear();
        lonFieldController.clear();
      });
    }
  }

  void clearButtonPressed() {
    setState(() {
      markerList.clear();
    });
  }

  void removeButtonPressed(int index) {
    setState(() {
      markerList.removeAt(index);
    });
  }

  void mapRightClick(tapPos, LatLng latLng) {
    setState(() {
      markerList.add(latLng);
    });
  }

  void buildMarkerList() {
    markers = markerList
        .map((point) => Marker(
              point: point,
              width: 60,
              height: 60,
              builder: (context) => const Icon(
                Icons.location_searching,
                size: 20,
                color: darkBlue,
              ),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    buildMarkerList();
    return FlutterMap(
      mapController: MapController(),
      options: MapOptions(
        zoom: 12,
        center: LatLng(63.43048272294254, 10.395004330455816),
        minZoom: 8,
        maxZoom: 18,
        onSecondaryTap: mapRightClick,
      ),
      nonRotatedChildren: [
        // Marker window
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.fromLTRB(15, 15, 15, 15),
          padding: const EdgeInsets.all(10),
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
          constraints: const BoxConstraints(
            maxWidth: 500,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Textfields and add button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedTextField(latFieldController, 'Enter Latitude'),
                  OutlinedTextField(lonFieldController, 'Enter Longitude'),
                  OutlinedButtonDark(addButtonPressed, 'Add'),
                ],
              ),

              // Path list window
              SizedBox(
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
                    itemCount: markerList.length,
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
              ),

              // Clear list button
              OutlinedButtonDark(clearButtonPressed, 'Clear'),
            ],
          ),
        ),
      ],
      children: [
        TileLayer(
          minZoom: 1,
          maxZoom: 18,
          backgroundColor: lightBlue,
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: const ['a', 'b', 'c'],
        ),
        MarkerLayer(
          markers: markers,
        ),
        PolylineLayer(
          polylines: [
            Polyline(
              points: markerList,
              strokeWidth: 2.0,
              color: const Color.fromARGB(255, 195, 0, 255),
              isDotted: true,
            ),
          ],
        )
      ],
    );
  }
}
