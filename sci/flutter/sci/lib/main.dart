import 'package:flutter/material.dart';
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,

          // Column elements
          children: <Widget>[
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
                const double edges = 5;
                const double sradius = 10;
                const double spadding = 10;

                // Box around status flags
                return Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(15),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(15),
                  ),

                  // Column for all the status flags
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(edges),
                        padding: const EdgeInsets.all(spadding),
                        decoration: BoxDecoration(
                          color: scolor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(sradius),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Connected',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: sfontsize),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                '$connected',
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: sfontsize),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(edges),
                        padding: const EdgeInsets.all(spadding),
                        decoration: BoxDecoration(
                          color: scolor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(sradius),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Sampling',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: sfontsize),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '$sampling',
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: sfontsize),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(edges),
                        padding: const EdgeInsets.all(spadding),
                        decoration: BoxDecoration(
                          color: scolor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(sradius),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Leak',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: sfontsize),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '$leak',
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: sfontsize),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(edges),
                        padding: const EdgeInsets.all(spadding),
                        decoration: BoxDecoration(
                          color: scolor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(sradius),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Align(
                              alignment: Alignment.center,
                              child: Text(
                                'RMS Pump',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: sfontsize),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '$rms_pump',
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: sfontsize),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(edges),
                        padding: const EdgeInsets.all(spadding),
                        decoration: BoxDecoration(
                          color: scolor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(sradius),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Align(
                              alignment: Alignment.center,
                              child: Text(
                                'RMS Valve',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: sfontsize),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '$rms_valve',
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: sfontsize),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(edges),
                        padding: const EdgeInsets.all(spadding),
                        decoration: BoxDecoration(
                          color: scolor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(sradius),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Align(
                              alignment: Alignment.center,
                              child: Text(
                                'RMS Full',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: sfontsize),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '$rms_full',
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: sfontsize),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(edges),
                        padding: const EdgeInsets.all(spadding),
                        decoration: BoxDecoration(
                          color: scolor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(sradius),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Align(
                              alignment: Alignment.center,
                              child: Text(
                                'RMS Leak',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: sfontsize),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '$rms_leak',
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: sfontsize),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              valueListenable: mqtt.statusdata,
            ),

            // Sample button
            //heightFactor: 2,
            FloatingActionButton.extended(
              label: const Text(
                'Start Sampling',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              backgroundColor: Colors.blueGrey,
              elevation: 5,
              hoverColor: Color.fromARGB(255, 126, 151, 194),
              hoverElevation: 10,
              splashColor: Colors.blue,
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
