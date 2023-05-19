import 'package:flutter/material.dart';
import 'package:sci/controllers/status_controller.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({super.key});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  String t0 = "Not pressed";
  String t1 = "Not pressed";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 52, 95),
      body: Container(
        child: Column(
          children: [
            GestureDetector(
              onTap: () => setState(
                () {
                  if (t0 == "Not pressed") {
                    t0 = "Pressed";
                  } else {
                    t0 = "Not pressed";
                  }
                },
              ),
              child: SizedBox(
                child: Text(
                  t0,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => setState(
                () {
                  if (t1 == "Not pressed") {
                    t1 = "Pressed";
                  } else {
                    t1 = "Not pressed";
                  }
                },
              ),
              child: SizedBox(
                child: Text(
                  t1,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
