import 'package:flutter/material.dart';

import 'package:sci/constants.dart';
import 'package:sci/widgets/container_scaled.dart';
import 'package:sci/controllers/mqtt_controller.dart';

class ImagesPage extends StatefulWidget {
  final MQTTController mqtt;
  const ImagesPage(this.mqtt, {super.key});

  @override
  State<ImagesPage> createState() => _ImagesPageState();
}

class _ImagesPageState extends State<ImagesPage> {
  // Page layout constants
  static const double div = 3;
  static const double controlBoxRatio = 1;
  static const double imageBoxRatio = 2;
  static const double boxMargin = 15;

  // Current active folder and file indexes
  int selectedFolder = -1;
  int selectedFile = -1;

  // Current sample selected
  String currSample = '';

  // Current image selected
  String currImage = '';

  // Decode samples
  List<String> buildSampleList(String names) {
    List<String> folderList = names.split(',');
    folderList = folderList..sort();
    return folderList;
  }

  // Decode images
  List<String> buildImagesList(String names) {
    List<String> imagesList = names.split(',');
    imagesList = imagesList..sort();
    return imagesList;
  }

  // Format sample list to be more readable
  List<String> formatSampleList(List<String> samples) {
    for (int i = 0; i < samples.length; i++) {
      samples[i] = samples[i].substring(0, 2) +
          "/" +
          samples[i].substring(2, 4) +
          "/" +
          samples[i].substring(4, 8) +
          " " +
          samples[i].substring(8, 10) +
          ":" +
          samples[i].substring(10, 12) +
          ":" +
          samples[i].substring(12, 14);
    }
    return samples;
  }

  // Creates the tiles(images) displayed when a sample(folder) is clicked
  List<Material> buildTileList(List<String> images) {
    List<Material> tilesList = []; // List of tiles to be returned
    // Build tiles
    for (int index = 0; index < images.length; index++) {
      // Wrapped in a Material widget to preserve animations/colors
      Material tile = Material(
        color: darkerBlue,
        child: ListTile(
          // Colors
          iconColor: lightBlue,
          textColor: lightBlue,
          selectedColor: lightBlue,
          hoverColor: darkBlue,
          selectedTileColor: darkBlue,

          // Icon
          leading: const Icon(Icons.image),

          // Content
          title: Text(images[index]),
          contentPadding: const EdgeInsets.fromLTRB(30, 0, 0, 0),

          // Mark as selected if current index matches
          selected: (index == selectedFile),

          // When tile is clicked
          onTap: () {
            widget.mqtt.publishMessage(topics.GET_SAMPLES, '');
            setState(() {
              selectedFile = index; // Mark as current file
              currImage = images[index];
            });
            print('selected image: $currImage');
          },
        ),
      );
      // Append tile to list
      tilesList.add(tile);
    }
    return tilesList;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Empty gap
        const SizedBox(width: 15),

        // Folder/file browser box
        ContainerScaled(
          div,
          controlBoxRatio,
          boxMargin,

          // Build expansion tiles (folders)
          ValueListenableBuilder(
            // Listen to data_samples topic
            valueListenable: widget.mqtt.data_samples,

            // Create tiles from data received
            builder: (BuildContext context, String value, Widget? child) {
              List<String> samples = buildSampleList(value);
              return ListView.builder(
                itemCount: samples.length,
                itemBuilder: (BuildContext context, int index) {
                  return ValueListenableBuilder(
                    // Listen to data_images topic
                    valueListenable: widget.mqtt.data_images,
                    builder:
                        (BuildContext context, String value, Widget? child) {
                      List<String> images = buildImagesList(value);
                      return ExpansionTile(
                        // Colors
                        backgroundColor: darkerBlue,
                        collapsedIconColor: lightBlue,
                        iconColor: lightBlue,

                        // Icon
                        leading: const Icon(Icons.folder),

                        // Folder name
                        title: Text(
                          samples[index],
                          style: const TextStyle(
                            color: lightBlue,
                            fontSize: 15,
                          ),
                        ),

                        // Allow only one to be open at a time
                        key: Key(selectedFolder.toString()),

                        // Initial state of expansion tile
                        initiallyExpanded: (index == selectedFolder),

                        // When clicked
                        onExpansionChanged: (expanding) {
                          if (expanding) {
                            selectedFolder = index;
                            currSample = samples[index];
                            widget.mqtt
                                .publishMessage(topics.GET_IMAGES, currSample);
                            print('Selected sample: $currSample');
                          }
                          selectedFile = -1;
                          setState(() {});
                        },

                        // Build ListTiles (Images)
                        children: buildTileList(images),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),

        // Empty gap
        const SizedBox(width: 15),

        // Image box
        ContainerScaled(
          div,
          imageBoxRatio,
          boxMargin,
          Align(
            alignment: Alignment.center,
            child: Text(''),
          ),
        ),
      ],
    );
  }
}
