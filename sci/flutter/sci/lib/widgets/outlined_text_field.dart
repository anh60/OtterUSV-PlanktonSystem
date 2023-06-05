import 'package:flutter/material.dart';

import 'package:sci/constants.dart';

class OutlinedTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool notActive;

  const OutlinedTextField(this.controller, this.label, this.notActive,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: darkerBlue,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(5),
      ),
      constraints: const BoxConstraints(
        minWidth: 100,
        maxWidth: 150,
        minHeight: 0,
        maxHeight: 50,
      ),
      child: TextFormField(
        enabled: notActive,
        controller: controller,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 15,
          color: lighterBlue,
        ),
        decoration: InputDecoration(
          focusColor: const Color.fromARGB(255, 169, 216, 255),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 169, 216, 255)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: lighterBlue),
          ),
          border: const OutlineInputBorder(),
          labelText: label,
          labelStyle: const TextStyle(
            fontSize: 15,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
