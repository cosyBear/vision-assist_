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
        // Pass the delta (dx, dy) instead of absolute positions
        onPositionChanged(details.delta.dx, details.delta.dy);
      },

        child: const Icon(
          Icons.add, // Big plus icon
          color: Colors.white, // Icon color
          size: 100, // Bigger icon size
        ),
      );
  }
}
