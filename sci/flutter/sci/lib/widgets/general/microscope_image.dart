import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../constants.dart';

class MicroscopeImage extends StatelessWidget {
  final ValueNotifier<String> valueNotifier;
  final double div;
  final double ratio;

  const MicroscopeImage(this.valueNotifier, this.div, this.ratio, {super.key});

  @override
  Widget build(BuildContext context) {
    // Container for wrapping image
    return Container(
      // Config
      margin: const EdgeInsets.only(top: 15, bottom: 15),
      width: getContainerWidth(context, div, ratio),
      height: getContainerWidth(context, div, ratio) * imageAspectRatio,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(5),
      ),
      alignment: Alignment.center,

      // Listen to mqtt image value
      child: ValueListenableBuilder<String>(
        valueListenable: valueNotifier,

        // Build and display image
        builder: (BuildContext context, String value, Widget? child) {
          // If no image is transmitted
          if (value == '0') {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Loading image',
                  style: TextStyle(color: darkerBlue, fontSize: 25),
                ),
                LoadingAnimationWidget.prograssiveDots(
                    color: darkerBlue, size: 50),
              ],
            );
          }

          // If not multiple of four, append n "="
          else {
            if (value.length % 4 > 0) {
              value += '=' * (4 - value.length % 4);
            }

            // Convert Base64 String to Image object
            var bytesImage = const Base64Decoder().convert(value);

            // Return image with rounded edges
            return ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: MemoryImage(bytesImage),
                fadeInDuration: const Duration(milliseconds: 100),
              ),
            );
          }
        },
      ),
    );
  }
}
