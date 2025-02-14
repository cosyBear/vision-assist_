import 'package:flutter/material.dart';

class DraggableButton extends StatelessWidget {
  final double xPos, yPos;
  final Function(double, double) onPositionChanged;

  const DraggableButton({super.key, required this.xPos, required this.yPos, required this.onPositionChanged});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: xPos,
      top: yPos,
      child: GestureDetector(
        onPanUpdate: (details) => onPositionChanged(details.delta.dx, details.delta.dy),
        child:  Image.asset(
          'assets/images/logo.png',
          width: 60,
          height: 60,
        ),
      ),
    );
  }
}
