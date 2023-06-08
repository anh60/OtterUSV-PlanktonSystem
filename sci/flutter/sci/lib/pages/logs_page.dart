import "package:flutter/material.dart";

import 'package:sci/constants.dart';
import 'package:sci/widgets/container_scaled.dart';

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
          children: [],
        );
      },
    );
  }
}
