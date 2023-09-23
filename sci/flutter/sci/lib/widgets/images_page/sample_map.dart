// build map
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sci/constants.dart';

// Build map markers
List<Marker> buildMarkerList(List<LatLng> markerList) {
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
  return markers;
}

class SampleMap extends StatelessWidget {
  MapController mapController;
  List<LatLng> markerList;

  SampleMap(this.mapController, this.markerList, {super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          zoom: 10,
          center: markerList[0],
          minZoom: 8,
          maxZoom: 18,
          keepAlive: true,
        ),
        children: [
          TileLayer(
            minZoom: 1,
            maxZoom: 18,
            backgroundColor: lightBlue,
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: buildMarkerList(markerList),
          ),
        ],
      ),
    );
  }
}
