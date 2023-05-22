import "package:flutter/material.dart";

class StatusTab extends StatefulWidget {
  String flagname;
  int flag;

  StatusTab(this.flagname, this.flag);

  @override
  State<StatusTab> createState() => _StatusTabState();
}

class _StatusTabState extends State<StatusTab> {
  static const double sfontsize = 20;
  static const Color scolor = Color.fromARGB(255, 77, 90, 114);
  static const double edges = 5;
  static const double sradius = 10;
  static const double spadding = 10;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Align(
            alignment: Alignment.center,
            child: Text(
              widget.flagname,
              style: const TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: sfontsize),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              widget.flag.toString(),
              style: const TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: sfontsize),
            ),
          ),
        ],
      ),
    );
  }
}
