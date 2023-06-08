import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:sci/constants.dart';
import 'package:sci/widgets/container_scaled.dart';
import 'package:sci/widgets/outlined_button_dark.dart';
import 'package:sci/widgets/outlined_text_field.dart';

class VehiclePage extends StatefulWidget {
  const VehiclePage({super.key});

  @override
  State<VehiclePage> createState() => _VehiclePageState();
}

class _VehiclePageState extends State<VehiclePage> {
  // Page layout constants
  static const double div = 3;
  static const double controlBoxRatio = 1;
  static const double mapBoxRatio = 2;
  static const double boxMargin = 15;

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

  void mapLongPress(tapPos, LatLng latLng) {
    setState(() {
      markerList.add(latLng);
    });
  }

  List<Marker> buildMarkerList() {
    return markers = markerList
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
    return Row(
      children: [
        const SizedBox(width: 15),
        ContainerScaled(
          div,
          controlBoxRatio,
          boxMargin,
          Padding(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 300,
                    child: Container(
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
                          return ExpansionTile(
                            backgroundColor: darkerBlue,
                            collapsedIconColor: lightBlue,
                            iconColor: lightBlue,
                            leading: const Icon(Icons.location_searching),
                            title: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: lightBlue,
                                fontSize: 15,
                              ),
                            ),
                            children: [
                              ListTile(
                                leading: const Icon(Icons.place),
                                title: Text('${markerList[index].latitude}'),
                                iconColor: lightBlue,
                                textColor: lightBlue,
                                contentPadding:
                                    const EdgeInsets.fromLTRB(30, 0, 0, 0),
                              ),
                              ListTile(
                                leading: const Icon(Icons.place),
                                title: Text('${markerList[index].longitude}'),
                                iconColor: lightBlue,
                                textColor: lightBlue,
                                contentPadding:
                                    const EdgeInsets.fromLTRB(30, 0, 0, 0),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Wrap(
                    spacing: 15,
                    runSpacing: 15,
                    children: [
                      OutlinedTextField(latFieldController, 'Latitude', true),
                      OutlinedTextField(lonFieldController, 'Longitude', true),
                      OutlinedButtonDark(addButtonPressed, 'Add', false),
                      OutlinedButtonDark(clearButtonPressed, 'Clear', false),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        ContainerScaled(
          div,
          mapBoxRatio,
          boxMargin,
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: FlutterMap(
              mapController: MapController(),
              options: MapOptions(
                zoom: 12,
                center: LatLng(63.43048272294254, 10.395004330455816),
                minZoom: 8,
                maxZoom: 18,
                onSecondaryTap: mapRightClick,
                onLongPress: mapLongPress,
              ),
              nonRotatedChildren: [],
              children: [
                TileLayer(
                  minZoom: 1,
                  maxZoom: 18,
                  backgroundColor: lightBlue,
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: buildMarkerList(),
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
            ),
          ),
        ),
      ],
    );
  }
}
