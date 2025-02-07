import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Image.asset(
      'assets/images/logo.png',
      width: screenWidth * 0.40,
      height: screenWidth * 0.40, // Maintain aspect ratio
      fit: BoxFit.contain,
    );
  }
}
