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
    final settings = Provider.of<AppSettingProvider>(context, listen: false);
    final buttonSize = settings.fontSize * 2;

    return GestureDetector(
      onPanUpdate: (details) {
        // Instead of passing xPos/yPos, pass the delta (dx, dy)
        onPositionChanged(details.delta.dx, details.delta.dy);
      },
      child: Image.asset(
        'assets/images/logo.png',
        width: buttonSize,
        height: buttonSize,
      ),
    );
  }
}
