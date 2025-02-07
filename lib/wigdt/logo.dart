import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final double size;
  final EdgeInsets padding;

  const Logo({
    super.key,
    this.size = 200,
    this.padding = const EdgeInsets.all(8.0),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: MediaQuery.of(context).size.width * 0.1),
        Image.asset(
          'assets/images/logo.png',
          width: MediaQuery.of(context).size.width * 0.3, // 30% of screen width
          height: MediaQuery.of(context).size.width * 0.3, // Maintain proportional height
        ),
      ],
    );
  }
}
