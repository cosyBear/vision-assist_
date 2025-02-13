import 'package:flutter/material.dart';

/*
  This class is a button that adjusts the font size.
  It uses the IconData class.
 */
class AdjustButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const AdjustButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: IconButton(
        icon: Icon(icon, size: 45, color: Colors.grey),
        onPressed: onPressed,
      ),
    );
  }
}
