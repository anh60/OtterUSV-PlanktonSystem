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

  // Folders
  List<String> folders = folderList;

  // Current files corresponding to folder
  List<String> files = [];

  String received = '';

  // Decode and create the folder names to be displayed on the main tiles
  List<String> buildFolderList(String names) {
    List<String> folderList = [];
    return folderList;
  }

  // Creates the tiles (file references) displayed when a folder is clicked
  List<Material> buildTileList() {
    List<Material> tilesList = []; // List of tiles to be returned
    // Build tiles
    for (int index = 0; index < files.length; index++) {
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
          title: Text(files[index]),
          contentPadding: const EdgeInsets.fromLTRB(30, 0, 0, 0),

          // Mark as selected if current index matches
          selected: (index == selectedFile),

          // When tile is clicked
          onTap: () {
            widget.mqtt.publishMessage(topics.GET_SAMPLES, '');
            setState(() {
              selectedFile = index; // Mark as current file
            });
            print('tapped tile: $selectedFile in folder $selectedFolder');
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
            valueListenable: widget.mqtt.data_samples,
            builder: (BuildContext context, String value, Widget? child) {
              print('data $value');
              return ListView.builder(
                itemCount: folders.length,
                itemBuilder: (BuildContext context, int index) {
                  return ExpansionTile(
                    // Colors
                    backgroundColor: darkerBlue,
                    collapsedIconColor: lightBlue,
                    iconColor: lightBlue,

                    // Icon
                    leading: const Icon(Icons.folder),

                    // Folder name
                    title: Text(
                      value,
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
                        files = getFiles(index);
                      }
                      selectedFile = -1;
                      setState(() {});
                    },

                    // Build ListTiles (Images)
                    children: buildTileList(),
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
            child: Text(received),
          ),
        ),
      ],
    );
  }
}
