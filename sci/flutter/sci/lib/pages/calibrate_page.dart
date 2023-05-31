import "dart:convert";

import "package:flutter/material.dart";

import "package:sci/constants.dart";

import "package:sci/controllers/mqtt_controller.dart";

class CalibratePage extends StatefulWidget {
  // MQTT Client
  final MQTTController mqtt;

  // Constructor
  const CalibratePage(this.mqtt, {super.key});

  @override
  State<CalibratePage> createState() => _CalibratePageState();
}

class _CalibratePageState extends State<CalibratePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          // Top box
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 77, 90, 114),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey.withOpacity(1),
                  spreadRadius: 3,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            constraints: const BoxConstraints(
              maxWidth: 600,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // Image
                ValueListenableBuilder<String>(
                  builder: (BuildContext context, String value, Widget? child) {
                    var bytesImage = const Base64Decoder().convert(value);
                    return Image.memory(
                      bytesImage,
                      scale: 2,
                    );
                  },
                  valueListenable: widget.mqtt.cal_photo,
                ),

                // Current position
                ValueListenableBuilder<String>(
                  builder: (BuildContext context, String value, Widget? child) {
                    int currPos = int.parse(value);
                    return Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                      decoration: BoxDecoration(
                        color: darkerBlue,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: lightBlue,
                          width: 1.0,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Current position',
                              style: TextStyle(
                                color: lightBlue,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              currPos.toString(),
                              style: const TextStyle(
                                color: lightBlue,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  valueListenable: widget.mqtt.cal_pos,
                ),
              ],
            ),
          ),

          // Bottom box
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 77, 90, 114),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey.withOpacity(1),
                  spreadRadius: 3,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            constraints: const BoxConstraints(
              maxWidth: 600,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Input text field
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: darkerBlue,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 150,
                        maxWidth: 150,
                        minHeight: 50,
                        maxHeight: 50,
                      ),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        style: const TextStyle(
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
                          labelText: 'Enter new value',
                          labelStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),

                    // Change position button
                    Container(
                      margin: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                      constraints: const BoxConstraints(
                        minWidth: 100,
                        maxWidth: 100,
                        minHeight: 50,
                        maxHeight: 50,
                      ),
                      child: FloatingActionButton.extended(
                        label: const Text(
                          'Send',
                          style: TextStyle(
                            color: Color.fromARGB(255, 169, 216, 255),
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
                          widget.mqtt.publishMessage(topics.CAL_NEXTPOS, '1');
                        },
                      ),
                    ),
                  ],
                ),

                // Reset button
                Container(
                  constraints: const BoxConstraints(
                    minWidth: 100,
                    maxWidth: 100,
                    minHeight: 50,
                    maxHeight: 50,
                  ),
                  child: FloatingActionButton.extended(
                    label: const Text(
                      'Reset',
                      style: TextStyle(
                        color: Color.fromARGB(255, 169, 216, 255),
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
                      widget.mqtt.publishMessage(topics.CAL_NEXTPOS, '1');
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
