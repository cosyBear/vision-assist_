import 'package:flutter/material.dart';

class DraggableButton extends StatelessWidget {
  final double xPos, yPos;
  final Function(double dx, double dy) onPositionChanged;

  const DraggableButton({
    super.key,
    required this.xPos,
    required this.yPos,
    required this.onPositionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        // Instead of passing xPos/yPos, pass the delta (dx, dy)
        onPositionChanged(details.delta.dx, details.delta.dy);
      },
      child: Image.asset(
        'assets/images/logo.png',
        width: 60,
        height: 60,
      ),
    );
  }
}
