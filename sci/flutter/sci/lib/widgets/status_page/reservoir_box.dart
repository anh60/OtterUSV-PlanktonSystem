import "package:flutter/material.dart";
import "package:sci/constants.dart";
import "package:sci/widgets/status_page/status_container.dart";
import "package:sci/widgets/status_page/status_tab.dart";

class ReservoirBox extends StatefulWidget {
  const ReservoirBox({super.key});

  @override
  State<ReservoirBox> createState() => _ReservoirBoxState();
}

class _ReservoirBoxState extends State<ReservoirBox> {
  @override
  Widget build(BuildContext context) {
    return const StatusContainer(
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // Vertical gap
          SizedBox(height: 5),

          // Label
          Text(
            'RESERVOIR',
            style: TextStyle(
              color: lightBlue,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Vertical gap
          SizedBox(height: 15),

          // Estimated water levels
          StatusTab('mL', 1000),
        ],
      ),
    );
  }
}
