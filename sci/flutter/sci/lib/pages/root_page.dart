import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:sci/controllers/mqtt_controller.dart';
import 'package:sci/constants.dart';
import 'package:sci/pages/status_page.dart';
import 'package:sci/pages/images_page.dart';
import 'package:sci/widgets/root_page/connected_icon.dart';

//---------------------------- FUNCTIONS/GLOBALS -------------------------------

// Width of navigation rail
const double navRailWidth = 50;

// Height of navigation rail
double getNavRailHeight(BuildContext context) {
  return (MediaQuery.of(context).size.height - (containerGap * 2));
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
          SingleChildScrollView(
            child: Container(
              height: getNavRailHeight(context),
              decoration: BoxDecoration(
                boxShadow: [containerShadow],
                borderRadius: BorderRadius.circular(rSmall),
              ),

              // Make edges curved
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(rSmall),
                  bottomRight: Radius.circular(rSmall),
                ),

                // Build NavigationRail
                child: NavigationRail(
                  minWidth: navRailWidth,
                  backgroundColor: darkBlue,
                  elevation: containerElevation,

                  // Connection Icon
                  trailing: ConnectedIcon(mqtt),

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
