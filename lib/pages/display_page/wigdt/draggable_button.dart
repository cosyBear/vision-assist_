import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../general/app_setting_provider.dart';

class DraggableButton extends StatelessWidget {
  final double xPos, yPos;
  final Function(double, double) onPositionChanged;

  const DraggableButton({
    super.key,
    required this.xPos,
    required this.yPos,
    required this.onPositionChanged
  });

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingProvider>(context, listen: false);
    double buttonSize = settings.fontSize * 2; // Button size is twice the font size

    return Positioned(
      left: xPos,
      top: yPos,
      child: GestureDetector(
        onPanUpdate: (details) => onPositionChanged(details.delta.dx, details.delta.dy),
        child:  Image.asset(
          'assets/images/logo.png',
          width: buttonSize,
          height: buttonSize,
        ),
      ),
    );
  }
}
