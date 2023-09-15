import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:sci/controllers/mqtt_controller.dart';
import 'package:sci/constants.dart';
import 'package:sci/pages/status_page.dart';
import 'package:sci/pages/images_page.dart';

//---------------------------- FUNCTIONS ---------------------------------------

// Set the connection status symbol
Icon setConnectionIcon(int connection) {
  if (connection == 1) {
    return const Icon(Icons.wifi, color: Colors.green);
  }
  return const Icon(Icons.wifi_off, color: Colors.red);
}

//---------------------------- WIDGET ------------------------------------------

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

//---------------------------- STATE -------------------------------------------

class _RootPageState extends State<RootPage> {
  //---------------------------- INIT ------------------------------------------

  // MQTT Client
  MQTTController mqtt = MQTTController();

  // Page variables
  late List<Widget> pages;
  int currentPage = 0;

  // Initial state
  @override
  void initState() {
    super.initState();

    // Initialize pages
    pages = [
      StatusPage(mqtt),
      ImagesPage(mqtt),
    ];

    // Initialize MQTT Client
    mqtt.connect();
  }

  //---------------------------- BUILD WIDGET ----------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundBlue,
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
                      minWidth: navRailWidth,
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
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // Current page, wrapped with animation
          PageTransitionSwitcher(
            duration: const Duration(milliseconds: 1000),
            transitionBuilder: (child, animation, secondaryAnimation) =>
                FadeThroughTransition(
              fillColor: lightBlue.withOpacity(0),
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            ),
            child: pages[currentPage],
          ),
        ],
      ),
    );
  }
}
