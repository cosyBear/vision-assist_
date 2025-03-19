import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../general/app_setting_provider.dart';

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
    final settings = Provider.of<AppSettingProvider>(context);
    Color buttonColor = settings.textColor;
    return GestureDetector(
      onPanUpdate: (details) {
        // Pass the delta (dx, dy) instead of absolute positions
        onPositionChanged(details.delta.dx, details.delta.dy);
      },

        child: Icon(
          Icons.title, // Big plus icon
          color: buttonColor, // Icon color
          size: 100, // Bigger icon size
        ),
      );
  }
}
