import 'package:flutter/material.dart';
class HeadingText  extends StatelessWidget {
  final String text;
  final TextAlign align;

  ///Returns a custom [Text] widget for accessing headline theme
  ///and has an optional alignment property.
  HeadingText({this.text, this.align});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headline,
      textAlign: align,
    );
  }
}