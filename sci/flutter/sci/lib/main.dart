import 'package:flutter/material.dart';
import 'package:sci/pages/status.dart';
import 'package:sci/controllers/mqtt_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int rms_pump = 0;
  int rms_valve = 0;
  int rms_full = 0;
  int rms_leak = 0;
  int connected = 0;
  int sampling = 0;
  int leak = 0;

  MQTTController mqtt = MQTTController();

  @override
  void initState() {
    super.initState();
    mqtt.connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 200, 220, 255),
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        title: const Text('Planktoscope Status'),
      ),
      body: Center(
        // Main column
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // Column elements
          children: <Widget>[
            // Heading for status
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Current Status',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),

            // Status flags
            ValueListenableBuilder<int>(
              builder: (BuildContext context, int value, Widget? child) {
                rms_pump = (value >> 0) & 1;
                rms_valve = (value >> 1) & 1;
                rms_full = (value >> 2) & 1;
                rms_leak = (value >> 3) & 1;
                connected = (value >> 4) & 1;
                sampling = (value >> 5) & 1;
                leak = (value >> 6) & 1;

                const double sfontsize = 20;
                const Color scolor = Color.fromARGB(255, 77, 90, 114);
                const double edges = 10;

                // Box around status flags
                return Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                  ),

                  // Column for all the status flags
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(edges),
                        decoration: BoxDecoration(
                          color: scolor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'RMS Pump $rms_pump',
                          style: const TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: sfontsize),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(edges),
                        decoration: BoxDecoration(
                          color: scolor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'RMS Valve $rms_valve',
                          style: const TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: sfontsize),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(edges),
                        decoration: BoxDecoration(
                          color: scolor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'RMS Full $rms_full',
                          style: const TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: sfontsize),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(edges),
                        decoration: BoxDecoration(
                          color: scolor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'RMS Leak $rms_leak',
                          style: const TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: sfontsize),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(edges),
                        decoration: BoxDecoration(
                          color: scolor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Connected $connected',
                          style: const TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: sfontsize),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(edges),
                        decoration: BoxDecoration(
                          color: scolor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Sampling $sampling',
                          style: const TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: sfontsize),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(edges),
                        decoration: BoxDecoration(
                          color: scolor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Leak $leak',
                          style: const TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: sfontsize),
                        ),
                      ),
                    ],
                  ),
                );
              },
              valueListenable: mqtt.statusdata,
            ),

            // Sample button
            FloatingActionButton.extended(
              label: const Text(
                'Start Sampling',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              backgroundColor: Colors.blueGrey,
              onPressed: () {
                mqtt.publishMessage('sample');
              },
            ),
          ],
        ),
      ),
    );
  }
}
