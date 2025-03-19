import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../general/app_setting_provider.dart';

class DraggableButton extends StatefulWidget {
  final double xPos, yPos;
  final Function(double dx, double dy) onPositionChanged;
  final bool isRotated;

  const DraggableButton({
    super.key,
    required this.xPos,
    required this.yPos,
    required this.onPositionChanged,
    required this.isRotated,
  });

  @override
  State<DraggableButton> createState() => _DraggableButtonState();
}

class _DraggableButtonState extends State<DraggableButton> {
  bool isRotated = false;

  void toggleRotation(bool rotate) {
    setState(() {
      isRotated = rotate;
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingProvider>(context);
    Color buttonColor = settings.textColor;

    return GestureDetector(
      onPanUpdate: (details) {
        widget.onPositionChanged(details.delta.dx, details.delta.dy);
      },
      child: Transform.rotate(
        angle: widget.isRotated ? 3.1416 : 0, // Use widget.isRotated for rotation
        child: Icon(
          Icons.title,
          color: buttonColor,
          size: 100,
        ),
      ),
    );
  }

}
