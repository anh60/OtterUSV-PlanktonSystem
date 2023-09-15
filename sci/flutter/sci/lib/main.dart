// ignore: slash_for_doc_comments
/**
 * main.dart
 * 
 * Andreas Holleland
 * 2023
 */

//---------------------------- PACKAGES ----------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sci/pages/root_page.dart';

//---------------------------- MAIN --------------------------------------------

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft])
      .then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RootPage(),
    );
  }
}
