import 'package:flutter/material.dart';

import 'package:sci/controllers/mqtt_controller.dart';

import 'package:sci/constants.dart';

import 'package:sci/pages/status_page.dart';
import 'package:sci/pages/images_page.dart';
import 'package:sci/pages/calibrate_page.dart';
import 'package:sci/pages/vehicle_page.dart';
import 'package:sci/pages/logs_page.dart';

void main() {
  runApp(const MyApp());
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

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  // MQTT Client
  MQTTController mqtt = MQTTController();

  // Pages
  late List<Widget> pages;
  int currentPage = 0;

  // Init
  @override
  void initState() {
    super.initState();
    pages = [
      StatusPage(mqtt),
      VehiclePage(),
      ImagesPage(),
      CalibratePage(mqtt),
      LogsPage()
    ];
    mqtt.connect();
  }

  // Rootpage Widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(206, 193, 238, 255),
      // Title bar at the top
      appBar: AppBar(
        elevation: 5,
        shadowColor: Colors.black,
        backgroundColor: darkBlue,
        centerTitle: true,
        title: const Text(
          'Planktoscope :  Connected',
          style: TextStyle(
            color: lightBlue,
          ),
        ),
      ),
      // Current page active
      body: pages[currentPage],
      // Page navigation bar at the bottom
      bottomNavigationBar: NavigationBar(
        backgroundColor: darkBlue,
        shadowColor: Colors.black,
        indicatorColor: darkerBlue,
        elevation: 5,
        destinations: const [
          NavigationDestination(
            icon: Icon(
              Icons.info,
              color: lightBlue,
            ),
            label: 'Status',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.directions_boat,
              color: lightBlue,
            ),
            label: 'Vehicle',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.photo_library,
              color: lightBlue,
            ),
            label: 'Images',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.settings,
              color: lightBlue,
            ),
            label: 'Calibrate',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.format_list_bulleted,
              color: lightBlue,
            ),
            label: 'Logs',
          ),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
          });
        },
        selectedIndex: currentPage,
      ),
    );
  }
}
