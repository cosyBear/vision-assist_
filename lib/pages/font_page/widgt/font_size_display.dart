import 'package:flutter/material.dart';
/*
  This class displays the font size.
*/
class FontSizeDisplay extends StatelessWidget {
  final double fontSize;

  const FontSizeDisplay({super.key, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Text(
      fontSize.toStringAsFixed(1),
      style: const TextStyle(fontSize: 18, color: Colors.grey),
    );
  }
}
