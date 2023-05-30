import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:sci/constants.dart';

class VehiclePage extends StatefulWidget {
  const VehiclePage({super.key});

  @override
  State<VehiclePage> createState() => _VehiclePageState();
}

class _VehiclePageState extends State<VehiclePage> {
  // List of markers
  List<LatLng> markerList = [];

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

  // Build page
  @override
  Widget build(BuildContext context) {
    // Update marker-layer list from LatLng list
    List<Marker> markers = markerList
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

    // Build map widget
    return FlutterMap(
      mapController: MapController(),
      options: MapOptions(
        // Default values on loading
        zoom: 12,
        center: LatLng(63.43048272294254, 10.395004330455816),

        // Constraints
        minZoom: 8,
        maxZoom: 18,

        // Functions
        onSecondaryTap: (tapPos, LatLng latLng) {
          print("tap pos: $tapPos, $latLng");
          setState(() {
            markerList.add(latLng);
          });
        },
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
              // Textfields and button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Latitude text field
                  Container(
                    decoration: BoxDecoration(
                      color: darkerBlue,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 100,
                      maxWidth: 150,
                      minHeight: 0,
                      maxHeight: 50,
                    ),
                    child: TextFormField(
                      controller: latFieldController,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        color: lighterBlue,
                      ),
                      decoration: const InputDecoration(
                        focusColor: Color.fromARGB(255, 169, 216, 255),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 169, 216, 255)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: lighterBlue),
                        ),
                        border: OutlineInputBorder(),
                        labelText: 'Enter Latitude',
                        labelStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  // Longitude text field
                  Container(
                    decoration: BoxDecoration(
                      color: darkerBlue,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 100,
                      maxWidth: 150,
                      minHeight: 0,
                      maxHeight: 50,
                    ),
                    child: TextFormField(
                      controller: lonFieldController,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        color: lighterBlue,
                      ),
                      decoration: const InputDecoration(
                        focusColor: Color.fromARGB(255, 169, 216, 255),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 169, 216, 255)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: lighterBlue),
                        ),
                        border: OutlineInputBorder(),
                        labelText: 'Enter Longitude',
                        labelStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),

                  // Add to path button
                  FloatingActionButton.extended(
                    label: const Text(
                      'Add',
                      style: TextStyle(
                        color: lightBlue,
                        fontSize: 15,
                      ),
                    ),
                    backgroundColor: darkerBlue,
                    elevation: 5,
                    hoverColor: darkBlue,
                    hoverElevation: 10,
                    splashColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 1, color: lightBlue),
                      borderRadius: BorderRadius.circular(5),
                    ),

                    // When pressed
                    onPressed: () {
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
                    },
                  ),
                ],
              ),

              // List of markers
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
                          Container(
                            constraints: BoxConstraints(minWidth: 300),
                            alignment: Alignment.center,
                            margin: const EdgeInsets.fromLTRB(25, 5, 25, 5),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: darkerBlue,
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                color: lightBlue,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Point: ${index + 1}',
                                  style: const TextStyle(
                                    color: lightBlue,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 25,
                            width: 25,
                            child: FloatingActionButton.extended(
                              label: const Text(
                                'X',
                                style: TextStyle(
                                  color: lightBlue,
                                  fontSize: 15,
                                ),
                              ),
                              backgroundColor: darkerBlue,
                              elevation: 5,
                              hoverColor: darkBlue,
                              hoverElevation: 10,
                              splashColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    width: 1, color: lightBlue),
                                borderRadius: BorderRadius.circular(5),
                              ),

                              // When pressed
                              onPressed: () {
                                setState(() {
                                  markerList.removeAt(index);
                                });
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),

              // Clear path button
              FloatingActionButton.extended(
                label: const Text(
                  'Clear path',
                  style: TextStyle(
                    color: lightBlue,
                    fontSize: 15,
                  ),
                ),
                backgroundColor: darkerBlue,
                elevation: 5,
                hoverColor: darkBlue,
                hoverElevation: 10,
                splashColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: lightBlue),
                  borderRadius: BorderRadius.circular(5),
                ),
                onPressed: () {
                  setState(() {
                    markerList.clear();
                  });
                },
              ),
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
              color: Color.fromARGB(255, 195, 0, 255),
              isDotted: true,
            ),
          ],
        )
      ],
    );
  }
}
