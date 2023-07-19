import 'package:flutter/material.dart';

import 'package:sci/controllers/mqtt_controller.dart';

import 'package:sci/constants.dart';

import 'package:sci/pages/status_page.dart';
import 'package:sci/pages/images_page.dart';
import 'package:sci/pages/vehicle_page.dart';

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

  List<bool> visible = [false, false, false, false];

  // Init
  @override
  void initState() {
    super.initState();

    // Initialize pages
    pages = [
      StatusPage(mqtt),
      ImagesPage(mqtt),
      const VehiclePage(),
    ];

    // Initialize MQTT Client
    mqtt.connect();
  }

  // Function for setting the connection status symbol
  Icon setConnectionIcon(int connection) {
    if (connection == 1) {
      return const Icon(Icons.wifi, color: Colors.green);
    }
    return const Icon(Icons.wifi_off, color: Colors.red);
  }

  // Rootpage Widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(206, 193, 238, 255),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // Sidebar
          ValueListenableBuilder<String>(
            // Listens to changes on the 'connected' flag over MQTT
            valueListenable: mqtt.status_connected,
            builder: (BuildContext context, String value, Widget? child) {
              int connection = int.parse(value);
              return SingleChildScrollView(
                // Container for setting size of NavigationRail
                child: Container(
                  height: (MediaQuery.of(context).size.height - 30),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueGrey.withOpacity(1),
                        spreadRadius: 3,
                        blurRadius: 9,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(5),
                  ),

                  // Make edges curved
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),

                    // Build NavigationRail
                    child: NavigationRail(
                      minWidth: 50,
                      backgroundColor: darkBlue,
                      elevation: 10,
                      trailing: Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: setConnectionIcon(connection),
                          ),
                        ),
                      ),

                      // Set current page with selected button
                      selectedIndex: currentPage,

                      // On button press
                      onDestinationSelected: (int index) {
                        setState(() {
                          currentPage = index;
                        });
                      },

                      // Mapping buttons to destinations (pages)
                      destinations: const <NavigationRailDestination>[
                        // Status page
                        NavigationRailDestination(
                          icon: Icon(
                            Icons.info,
                            color: lightBlue,
                          ),
                          label: Text(''),
                        ),

                        // Images page
                        NavigationRailDestination(
                          icon: Icon(
                            Icons.photo_library,
                            color: lightBlue,
                          ),
                          label: Text(''),
                        ),

                        // Vehicle page
                        NavigationRailDestination(
                          icon: Icon(
                            Icons.directions_boat,
                            color: lightBlue,
                          ),
                          label: Text(''),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // Current page
          pages[currentPage],
        ],
      ),
    );
  }
}
