import 'package:discover_deep_cove/util/screen.dart';
import 'package:flutter/material.dart';

class Heading extends StatelessWidget {
  final String text;
  final TextAlign align;
  final double size;

  ///Returns a custom [Text] widget for accessing headline theme
  ///and has an optional alignment property.
  Heading(this.text, {this.align = TextAlign.center, this.size = 0});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.fade,
      style: TextStyle(
        fontSize: size == 0 ? Screen.width(context) <= 350 ? 25 : 30 : size,
        color: Colors.white,
      ),
      textAlign: align,
    );
  }
}
