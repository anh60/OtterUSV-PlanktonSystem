import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sci/widgets/status_page/status_tab.dart';
import 'package:transparent_image/transparent_image.dart';

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

  // Image aspect ratio
  double aspectRatio = 9 / 16;

  // String printed when loading images
  String loadingString = 'Loading';

  // Current active folder and file indexes
  int selectedFolder = -1;
  int selectedFile = -1;

  // Current sample selected
  String currSample = '';

  // Current image selected
  String currImage = '';

  // State of the toggle switch
  List<bool> toggleButtonState = [true, false];

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

  // Format sample/image filenames to be more readable
  String formatDateTime(String filename) {
    if (filename == loadingString) {
      return filename;
    }
    filename =
        // Day
        filename.substring(6, 8) +
            "/" +
            // Month
            filename.substring(4, 6) +
            "/" +
            // Year
            filename.substring(0, 4) +
            " " +
            // Hour
            filename.substring(8, 10) +
            ":" +
            // Minute
            filename.substring(10, 12) +
            ":" +
            // Second
            filename.substring(12, 14);
    return filename;
  }

  Widget checkIfLoading(String value, int index) {
    if (index == 0) {
      if (value == loadingString) {
        return LoadingAnimationWidget.prograssiveDots(
            color: lightBlue, size: 25);
      }
    }
    return const Icon(Icons.image);
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
          leading: checkIfLoading(images[index], index),

          // Content
          title: Text(formatDateTime(images[index])),
          contentPadding: const EdgeInsets.fromLTRB(30, 0, 0, 0),

          // Mark as selected if current index matches
          selected: (index == selectedFile),

          // When tile is clicked
          onTap: () {
            setState(() {
              widget.mqtt.data_image.value = '0';
              selectedFile = index; // Mark as current file
              currImage = images[index];
            });
            widget.mqtt.publishMessage(topics.GET_IMAGE, currImage);
            print('selected image: $currImage');
          },
        ),
      );
      // Append tile to list
      tilesList.add(tile);
    }
    return tilesList;
  }

  int checkIfSamples(List<String> sampleList) {
    if (sampleList[0] == '0') {
      return 0;
    }
    return sampleList.length;
  }

  double setImageWidth(BuildContext context) {
    return ((((MediaQuery.of(context).size.width) / div) * imageBoxRatio) -
        (40) -
        (15 / 2));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                itemCount: checkIfSamples(samples),
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
                          formatDateTime(samples[index]),
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
                            widget.mqtt.data_images.value = loadingString;
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
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(
                // Config
                padding: const EdgeInsets.all(0),
                margin: const EdgeInsets.only(top: 15, bottom: 15),
                width: setImageWidth(context),
                height: setImageWidth(context) * aspectRatio,
                decoration: BoxDecoration(
                  //color: darkBlue,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5),
                ),
                alignment: Alignment.center,

                // Image
                child: ValueListenableBuilder<String>(
                  // Listen to image value received over mqtt
                  valueListenable: widget.mqtt.data_image,

                  // Build and display image
                  builder: (BuildContext context, String value, Widget? child) {
                    // If no image is transmitted
                    if (value == '0') {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Loading image',
                            style: TextStyle(color: darkBlue, fontSize: 25),
                          ),
                          LoadingAnimationWidget.prograssiveDots(
                              color: darkBlue, size: 50),
                        ],
                      );
                    }

                    // Append n "=" if size is not multiple of four
                    else {
                      if (value.length % 4 > 0) {
                        value += '=' * (4 - value.length % 4);
                      }

                      // Convert Base64 String to Image object
                      var bytesImage = const Base64Decoder().convert(value);
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: FadeInImage(
                          placeholder: MemoryImage(kTransparentImage),
                          image: MemoryImage(bytesImage),
                          fadeInDuration: const Duration(milliseconds: 300),
                        ),
                      );
                    }
                  },
                ),
              ),
              Container(
                // Config
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.only(top: 15, bottom: 15),
                width: ((((MediaQuery.of(context).size.width) / div) *
                        imageBoxRatio) -
                    (40) -
                    (15 / 2)),
                decoration: BoxDecoration(
                  color: darkBlue,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      constraints:
                          BoxConstraints(maxWidth: setImageWidth(context) / 2),
                      child: const Column(
                        children: [
                          StatusTab('Time of sample', 0),
                          SizedBox(height: 15),
                          StatusTab('Latitude', 0),
                          SizedBox(height: 15),
                          StatusTab('Longitude', 0)
                        ],
                      ),
                    ),
                    ToggleButtons(
                      isSelected: toggleButtonState,

                      onPressed: (int index) {
                        for (int i = 0; i < toggleButtonState.length; i++) {
                          if (i == index) {
                            toggleButtonState[i] = true;
                          } else {
                            toggleButtonState[i] = false;
                          }
                        }
                        setState(() {});
                      },

                      // Colors
                      borderColor: lightBlue,
                      selectedColor: lightBlue,
                      color: darkerBlue,
                      fillColor: darkerBlue,
                      splashColor: Colors.blue,
                      selectedBorderColor: lightBlue,
                      hoverColor: Color.fromARGB(92, 144, 220, 255),

                      // Border
                      renderBorder: true,
                      borderWidth: 1,
                      borderRadius: BorderRadius.circular(10),

                      // Content
                      children: [
                        Container(
                          width: 100,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Image'),
                              Icon(
                                Icons.image,
                                size: 25,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 100,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Map'),
                              Icon(
                                Icons.map,
                                size: 25,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
