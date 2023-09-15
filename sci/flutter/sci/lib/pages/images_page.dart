// ignore: slash_for_doc_comments
/**
 * images_page.dart
 * 
 * Andreas Holleland
 * 2023
 */

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sci/widgets/general/microscope_image.dart';
import 'package:sci/widgets/images_page/sample_map.dart';
import 'package:sci/widgets/images_page/string_status_tab.dart';
import 'package:sci/constants.dart';
import 'package:sci/widgets/general/container_scaled.dart';
import 'package:sci/controllers/mqtt_controller.dart';
import 'package:sci/controllers/image_controller.dart';

class ImagesPage extends StatefulWidget {
  final MQTTController mqtt;
  const ImagesPage(this.mqtt, {super.key});

  @override
  State<ImagesPage> createState() => _ImagesPageState();
}

class _ImagesPageState extends State<ImagesPage> {
  // Current active folder and file indexes
  int selectedFolder = -1;
  int selectedFile = -1;

  // Current sample selected
  String currSample = '';

  // Current image selected
  String currImage = '';

  // Map
  MapController mapController = MapController();
  bool mapReady = false;

  // Values to be displayed below image/map
  String latitude = '';
  String longitude = '';
  String sampleTime = '';
  String imageTime = '';

  // Position
  String lat = '';
  String lon = '';

  // List of markers (holds default position on startup)
  List<LatLng> markerList = [LatLng(63.43048272294254, 10.395004330455816)];

  // Sample delete button callback
  void deleteButton() {
    widget.mqtt.publishMessage(topics.RM_SAMPLE, currSample);
  }

  // State of the toggle switch
  List<bool> toggleButtonState = [true, false];

  // Decode samples
  List<String> buildSampleList(String names) {
    List<String> folderList = names.split(',');
    folderList = folderList..sort();
    return folderList;
  }

  // Decode filenames of images and create list
  List<String> buildImageList(String names) {
    // Split the CSVs
    List<String> imageList = names.split(',');

    // Get and remove position (lat/lon) from the list
    if (imageList[0] != loading) {
      lon = imageList.removeAt(imageList.length - 1);
      lat = imageList.removeAt(imageList.length - 1);
    }

    // Sort list
    imageList = imageList..sort();
    return imageList;
  }

  // Format sample/image filenames to be more readable
  String formatDateTime(String filename) {
    // Return loading string when no data has been received
    if (filename == loading || filename == '') {
      return filename;
    }

    // If data has been received, format the string
    filename =
        // ignore: prefer_interpolation_to_compose_strings
        filename.substring(6, 8) +
            "/" +
            filename.substring(4, 6) +
            "/" +
            filename.substring(0, 4) +
            " " +
            filename.substring(8, 10) +
            ":" +
            filename.substring(10, 12) +
            ":" +
            filename.substring(12, 14);
    return filename;
  }

  // Set the icon for an image tile
  Widget setTileIcon(String value, int index) {
    // If loading
    if (index == 0) {
      if (value == loading) {
        // Return the loading animation icon
        return LoadingAnimationWidget.prograssiveDots(
            color: lightBlue, size: 25);
      }
    }

    // If not loading, return the image icon
    return const Icon(Icons.image);
  }

  // When an image til is tapped callback
  void onImageTapped(int index, List<String> images) {
    // If loading, ignore tap
    if (images[index] == loading) {
      return;
    }

    // Notify image listener to wait for a new image
    widget.mqtt.data_image.value = '0';

    // Set selected image index to index of selected image
    selectedFile = index;

    // Set current image name to selected image name
    currImage = images[index];

    // Set values to be displayed below image/map
    sampleTime = currSample;
    imageTime = currImage;
    latitude = lat;
    longitude = lon;

    // Set map marker to current sample coordinates
    LatLng marker = LatLng(double.parse(lat), double.parse(lon));
    markerList.removeAt(0);
    markerList.add(marker);

    // Move camera to coordinates if active
    if (mapReady) {
      mapController.move(marker, mapController.zoom);
    }
    setState(() {});

    // Request selected image
    widget.mqtt.publishMessage(topics.GET_IMAGE, currImage);
  }

  // Creates the tiles(images) displayed when a sample(folder) is clicked
  List<Widget> buildImageTiles(List<String> images) {
    List<Widget> tilesList = [];
    for (int index = 0; index < images.length; index++) {
      // Wrapped in a Material widget to preserve animations/colors
      Material tile = Material(
        color: darkerBlue,
        child: ListTile(
          // Colors
          iconColor: lightBlue,
          textColor: lightBlue,
          selectedColor: Colors.white,
          hoverColor: darkBlue,
          selectedTileColor: darkerBlue,

          // Icon
          leading: setTileIcon(images[index], index),

          // Title of tile (image capture time)
          title: Text(
            formatDateTime(images[index]),
            style: const TextStyle(fontSize: mainFontSize),
          ),

          // Make empty space on left side
          contentPadding: const EdgeInsets.only(left: 30),

          // Mark as selected if current index matches
          selected: (index == selectedFile),

          // When tile is clicked
          onTap: () {
            onImageTapped(index, images);
          },
        ),
      );
      // Append tile to list
      tilesList.add(tile);
    }
    tilesList.add(
      Padding(
        padding: const EdgeInsets.only(bottom: 10, right: 10, top: 10),
        child: Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: deleteButton,
            icon: const Icon(Icons.delete),
            label: const Text('Remove'),
            style: TextButton.styleFrom(foregroundColor: lightBlue),
          ),
        ),
      ),
    );
    return tilesList;
  }

  // Check if the sample list is empty
  int checkIfSamples(List<String> sampleList) {
    if (sampleList[0] == '') {
      return 0;
    }
    return sampleList.length;
  }

  // Check toggle button state
  Widget checkToggleButton(List<bool> buttonState) {
    if (buttonState[0]) {
      mapReady = false;
      return MicroscopeImage(widget.mqtt.data_image, div, rightRatio);
    } else {
      mapReady = true;
      return SampleMap(mapController, markerList);
    }
  }

  // Get available height for the info panel (below image)
  double getInfoHeight(BuildContext context) {
    // Calculate image height
    double imageHeight = getImageHeight(context, div, rightRatio);

    // Calculate available space
    double availableSpace =
        MediaQuery.of(context).size.height - imageHeight - 45;

    // If there is enough space, stretch to fit screen
    if (availableSpace > 185) {
      return availableSpace;
    }

    // If not, force minimum size
    return 185;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Empty gap
        const SizedBox(width: 15),

        // Folder/file browser (left)
        ContainerScaled(
          div,
          leftRatio,
          boxMargin,

          // Build expansion tiles (folders)
          ValueListenableBuilder(
            // Listen to data_samples topic
            valueListenable: widget.mqtt.data_samples,

            // Create tiles from data received
            builder: (BuildContext context, String value, Widget? child) {
              List<String> samples = buildSampleList(value);
              return ListView.builder(
                // Get number of samples
                itemCount: checkIfSamples(samples),
                itemBuilder: (BuildContext context, int index) {
                  // Listen to data_images topic
                  return ValueListenableBuilder(
                    valueListenable: widget.mqtt.data_images,
                    builder:
                        (BuildContext context, String value, Widget? child) {
                      // Get list of images
                      List<String> images;

                      if (value != '0') {
                        images = buildImageList(value);
                      } else {
                        images = buildImageList(loading);
                      }

                      // Set rounded edges
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(5),

                        // Build expansion tile
                        child: ExpansionTile(
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
                              fontSize: mainFontSize,
                            ),
                          ),

                          tilePadding:
                              const EdgeInsets.only(left: 10, right: 10),

                          // Allow only one to be open at a time
                          key: Key(selectedFolder.toString()),

                          // Initial state of expansion tile
                          initiallyExpanded: (index == selectedFolder),

                          // When clicked
                          onExpansionChanged: (expanding) {
                            if (expanding) {
                              // Clear previous data
                              widget.mqtt.data_images.value = loading;

                              // Set current sample index
                              selectedFolder = index;

                              // Set current sample value
                              currSample = samples[index];

                              // Get images corresponding to selected sample
                              widget.mqtt.publishMessage(
                                  topics.GET_IMAGES, currSample);
                            }

                            // Reset previously selected image
                            selectedFile = -1;
                            setState(() {});
                          },

                          // Build ListTiles (Images)
                          children: buildImageTiles(images),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),

        // Empty gap
        const SizedBox(width: containerGap),

        // Image/map and data (right)
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          clipBehavior: Clip.none,
          child: Column(
            children: [
              // Empty gap
              const SizedBox(height: containerGap),

              // Image and map
              Container(
                // Config
                width: getAvailableWidth(context, div, rightRatio),
                height: getImageHeight(context, div, rightRatio),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(rSmall),
                  boxShadow: [containerShadow],
                ),
                alignment: Alignment.center,
                child: checkToggleButton(toggleButtonState),
              ),

              // Empty gap
              const SizedBox(height: containerGap),

              // Image info
              Container(
                width: getAvailableWidth(context, div, rightRatio),
                height: getInfoHeight(context),
                decoration: BoxDecoration(
                  color: darkBlue,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(rSmall),
                  boxShadow: [containerShadow],
                ),

                // Split container content horizontally
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // --- Status tabs (time and pos) ---
                    Container(
                      padding: const EdgeInsets.all(15),
                      constraints: BoxConstraints(
                          maxWidth:
                              (getAvailableWidth(context, div, rightRatio) /
                                      3) *
                                  2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Date
                          StringStatusTab(
                            'Sample time',
                            formatDateTime(sampleTime),
                          ),

                          // Vertical gap
                          const SizedBox(height: containerGap),

                          // Time
                          StringStatusTab(
                            'Image time',
                            formatDateTime(imageTime),
                          ),

                          // Vertical gap
                          const SizedBox(height: containerGap),

                          // Latitude
                          StringStatusTab('Latitude', latitude),

                          // Vertical gap
                          const SizedBox(height: containerGap),

                          // Longitude
                          StringStatusTab('Longitude', longitude),
                        ],
                      ),
                    ),

                    // --- Toggle switch (image/map) ---
                    ToggleButtons(
                      direction: Axis.vertical,
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
                      hoverColor: const Color.fromARGB(92, 144, 220, 255),

                      // Border
                      renderBorder: true,
                      borderWidth: 1,
                      borderRadius: BorderRadius.circular(rBig),

                      // Content
                      children: const [
                        SizedBox(
                          height: 75,
                          width: 75,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.image,
                                size: 25,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 75,
                          width: 75,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.map,
                                size: 25,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: containerGap),
                  ],
                ),
              ),

              // Empty gap
              const SizedBox(height: containerGap),
            ],
          ),
        ),
      ],
    );
  }
}
