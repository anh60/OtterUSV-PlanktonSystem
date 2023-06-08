import "package:flutter/material.dart";
import 'package:latlong2/latlong.dart';

import 'package:sci/constants.dart';

import 'package:sci/classes/sample_image.dart';
import 'package:sci/widgets/container_scaled.dart';

class ImagesPage extends StatefulWidget {
  const ImagesPage({super.key});

  @override
  State<ImagesPage> createState() => _ImagesPageState();
}

class _ImagesPageState extends State<ImagesPage> {
  // Page layout constants
  static const double div = 3;
  static const double controlBoxRatio = 1;
  static const double imageBoxRatio = 2;
  static const double boxMargin = 15;

  // Folder List
  List<String> sampleList = [
    '6/4/2023/18:31:12',
    '6/4/2023/18:31:12',
    '6/4/2023/18:31:12',
    '6/4/2023/18:31:12',
    '6/4/2023/18:31:12',
    '6/4/2023/18:31:12',
    '6/4/2023/18:31:12',
    '6/4/2023/18:31:12',
    '6/4/2023/18:31:12',
    '6/4/2023/18:31:12',
    '6/4/2023/18:31:12',
    '6/4/2023/18:31:12',
    '6/4/2023/18:31:12',
    '6/4/2023/18:31:12',
    '6/4/2023/18:31:12',
    '6/4/2023/18:31:12',
  ];

  // Image List
  List<SampleImage> imageList = [
    SampleImage('6/4/2023/18:31:12', LatLng(63.5, 10.5), ''),
    SampleImage('6/4/2023/18:31:13', LatLng(63.5, 10.5), ''),
    SampleImage('6/4/2023/18:31:14', LatLng(63.5, 10.5), ''),
    SampleImage('6/4/2023/18:31:15', LatLng(63.5, 10.5), ''),
    SampleImage('6/4/2023/18:31:16', LatLng(63.5, 10.5), ''),
    SampleImage('6/4/2023/18:31:17', LatLng(63.5, 10.5), ''),
    SampleImage('6/4/2023/18:31:18', LatLng(63.5, 10.5), ''),
    SampleImage('6/4/2023/18:31:19', LatLng(63.5, 10.5), ''),
  ];

  List<ListTile> buildTileList() {
    List<ListTile> tilesList = [];
    for (int i = 0; i < imageList.length; i++) {
      ListTile tile = ListTile(
        leading: const Icon(Icons.image),
        title: Text(imageList[i].timestamp),
        iconColor: lightBlue,
        textColor: lightBlue,
        hoverColor: lightBlue,
        selectedColor: lightBlue,
        selectedTileColor: lightBlue,
        contentPadding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
        onTap: () {
          setState(() {
            activeImage = i;
          });
          print('tapped tile: $activeImage in folder $activeFolder');
        },
      );
      tilesList.add(tile);
    }
    return tilesList;
  }

  int activeFolder = 0;
  int activeImage = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 15),
        ContainerScaled(
          div,
          controlBoxRatio,
          boxMargin,
          ListView.builder(
            itemCount: sampleList.length,
            itemBuilder: (BuildContext context, int index) {
              return ExpansionTile(
                // Configuration
                backgroundColor: darkerBlue,
                collapsedIconColor: lightBlue,
                iconColor: lightBlue,

                // Icon
                leading: const Icon(Icons.folder),

                // Name
                title: Text(
                  sampleList[index],
                  style: const TextStyle(
                    color: lightBlue,
                    fontSize: 15,
                  ),
                ),

                // When clicked (expanded)
                onExpansionChanged: (expanding) {
                  if (expanding) {
                    activeFolder = index;
                  }
                },

                // Build ListTiles (Images)
                children: buildTileList(),
              );
            },
          ),
        ),
        const SizedBox(width: 15),
        const ContainerScaled(
          div,
          imageBoxRatio,
          boxMargin,
          Align(
            alignment: Alignment.center,
            child: Text('IMAGE HERE'),
          ),
        ),
      ],
    );
  }
}
