// ignore: slash_for_doc_comments
/**
 * constants.dart
 * 
 * Andreas Holleland
 * 2023
 */

import 'package:flutter/material.dart';

// MQTT setup
//const String mqtt_broker = "mqtt.eclipseprojects.io";
const String mqtt_broker = "broker.hivemq.com";
const String mqtt_client_name = "pscope_sci";
const int mqtt_broker_port = 1883;

// MQTT Topics
abstract class topics {
  // Vehicle position
  static const String VEHICLE_POS = "planktoscope/vehicle/position";

  // Status
  static const String STATUS_FLAGS = "planktoscope/status/flags";
  static const String STATUS_CONNECTED = "planktoscope/status/connected";

  // PIS Control
  static const String CTRL_SAMPLE = "planktoscope/control/sample";
  static const String CTRL_SAMPLE_PUMP = "planktoscope/control/sample_pump";
  static const String CTRL_STOP = "planktoscope/control/stop";
  static const String CTRL_IMAGE = "planktoscope/control/capture_image";

  // RMS Control
  static const String CTRL_RMS_PUMP = "planktoscope/control/pump";
  static const String CTRL_RMS_VALVE = "planktoscope/control/valve";
  static const String CTRL_RMS_STOP = "planktoscope/control/stop";

  // Calibrate
  static const String CAL_CURRPOS = "planktoscope/calibrate/currpos";
  static const String CAL_NEXTPOS = "planktoscope/calibrate/nextpos";
  static const String CAL_CURRLED = "planktoscope/calibrate/currled";
  static const String CAL_NEXTLED = "planktoscope/calibrate/nextled";
  static const String IMAGE = "planktoscope/calibrate/photo";

  // --- Images file system

  // Commands
  static const String GET_SAMPLES = "planktoscope/data/get_samples";
  static const String GET_IMAGES = "planktoscope/data/get_images";
  static const String GET_IMAGE = "planktoscope/data/get_image";

  // Data
  static const String DATA_SAMPLES = "planktoscope/data/samples";
  static const String DATA_IMAGES = "planktoscope/data/images";
  static const String DATA_IMAGE = "planktoscope/data/image";

  static const String RM_SAMPLE = "planktoscope/data/rm_samples";
  static const String RM_IMAGE = "planktoscope/data/rm_image";
}

// Image aspect ratio
double imageAspectRatio = 9 / 16;

// Returns the available width for right container
double getAvailableWidth(BuildContext context, double div, double ratio) {
  double width = MediaQuery.of(context).size.width;
  return (((width / div) * ratio) - 47.5);
}

// Returns the appropriate height to set for an image depending on aspect ratio
double getImageHeight(BuildContext context, double div, double ratio) {
  return getAvailableWidth(context, div, ratio) * imageAspectRatio;
}

// Font size
const double mainFontSize = 12.5;

// Gap between the displayed containers
const double containerGap = 15;
const double containerElevation = 10;

// Border radiuses
const double rSmall = 5;
const double rBig = 10;

// Colors used
const Color darkBlue = Color.fromARGB(255, 77, 90, 114);
const Color darkerBlue = Color.fromARGB(255, 54, 67, 92);
const Color lightBlue = Color.fromARGB(255, 169, 216, 255);
const Color lighterBlue = Color.fromARGB(255, 200, 220, 255);
const Color backgroundBlue = Color.fromARGB(206, 193, 238, 255);

// Shadow under containers
BoxShadow containerShadow = BoxShadow(
  color: Colors.blueGrey.withOpacity(1),
  spreadRadius: 3,
  blurRadius: 9,
  offset: const Offset(0, 3),
);
