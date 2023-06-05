import "package:flutter/material.dart";

import 'package:sci/constants.dart';

class LogsPage extends StatefulWidget {
  const LogsPage({super.key});

  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  // Page layout constants
  static const double div = 3;
  static const double box1Ratio = 1;
  static const double box2Ratio = 2;
  static const double boxMargin = 20;

  // Folder List
  List<String> logList = [
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
    '6/4/2023/18:31:12',
    '6/4/2023/18:31:12',
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // File selection box
            Container(
              // Configuration
              height: constraints.maxHeight,
              width: (((constraints.maxWidth / div) * box1Ratio) - boxMargin),
              margin: const EdgeInsets.fromLTRB(0, 15, 0, 15),
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

              //Content
              child: ListView.builder(
                itemCount: logList.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return ExpansionTile(
                    // Configuration
                    backgroundColor: darkerBlue,
                    collapsedIconColor: lightBlue,
                    iconColor: lightBlue,

                    // Content
                    title: Text(
                      logList[index],
                      style: const TextStyle(
                        color: lightBlue,
                        fontSize: 15,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Image box
            Container(
              // Configuration
              height: constraints.maxHeight,
              width: (((constraints.maxWidth / div) * box2Ratio) - boxMargin),
              margin: const EdgeInsets.fromLTRB(0, 15, 0, 15),
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
            ),
          ],
        );
      },
    );
  }
}
