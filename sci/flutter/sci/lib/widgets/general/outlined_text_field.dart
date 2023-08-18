// ignore: slash_for_doc_comments
/**
 * outlined_text_field.dart
 * 
 * Andreas Holleland
 * 2023
 */

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
        minWidth: 90,
        maxWidth: 90,
        minHeight: 30,
        maxHeight: 30,
      ),
      child: TextFormField(
        enabled: !notActive,
        controller: controller,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 12.5,
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
            fontSize: 10,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
