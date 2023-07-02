import 'package:flutter/material.dart';

const String mqtt_broker = "mqtt.eclipseprojects.io";
const String mqtt_client_name = "sci_client";
const int mqtt_broker_port = 1883;

const String db_server_address = "127.0.0.1";

// MQTT Topics
abstract class topics {
  // Status
  static const String STATUS_FLAGS = "planktoscope/status/flags";
  static const String STATUS_CONNECTED = "planktoscope/status/connected";

  // Mode
  static const String MODE_AUTO = "planktoscope/mode/autonomous";

  // Control
  static const String CTRL_SAMPLE = "planktoscope/control/sample";
  static const String CTRL_SAMPLE_PUMP = "planktoscope/control/sample_pump";
  static const String CTRL_STOP = "planktoscope/control/stop";

  // RMS Control
  static const String CTRL_RMS_PUMP = "planktoscope/control/pump";
  static const String CTRL_RMS_VALVE = "planktoscope/control/valve";
  static const String CTRL_RMS_STOP = "planktoscope/control/stop";

  // Calibrate
  static const String CAL_CURRPOS = "planktoscope/calibrate/currpos";
  static const String CAL_NEXTPOS = "planktoscope/calibrate/nextpos";
  static const String CAL_PHOTO = "planktoscope/calibrate/photo";
}

const Color darkBlue = Color.fromARGB(255, 77, 90, 114);
const Color darkerBlue = Color.fromARGB(255, 54, 67, 92);
const Color lightBlue = Color.fromARGB(255, 169, 216, 255);
const Color lighterBlue = Color.fromARGB(255, 200, 220, 255);

//folder and file placeholders for testing
List<String> folderList = [
  "Folder 1",
  "Folder 2",
  "Folder 3",
  "Folder 4",
  "Folder 5",
  "Folder 6",
  "Folder 7",
  "Folder 8",
  "Folder 9",
  "Folder 10",
];

List<String> files1 = [
  "1-File 1",
  "1-File 2",
  "1-File 3",
  "1-File 4",
  "1-File 5",
  "1-File 6",
  "1-File 7",
];
List<String> files2 = [
  "2-File 1",
  "2-File 2",
  "2-File 3",
  "2-File 4",
];
List<String> files3 = [
  "3-File 1",
  "3-File 2",
  "3-File 3",
  "3-File 4",
  "3-File 5",
  "3-File 6",
];
List<String> files4 = [
  "4-File 1",
  "4-File 2",
];

List<String> getFiles(int folderIndex) {
  switch (folderIndex) {
    case 0:
      return files1;
    case 1:
      return files2;
    case 2:
      return files3;
    case 3:
      return files4;
    default:
      return files1;
  }
}
