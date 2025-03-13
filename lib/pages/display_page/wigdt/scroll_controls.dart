import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../general/app_setting_provider.dart';

class ScrollControls extends StatefulWidget {
  const ScrollControls({super.key});

  @override
  ScrollControlsState createState() => ScrollControlsState();
}

class ScrollControlsState extends State<ScrollControls> {
  String? _speedLabel;

  void _increaseScrollSpeed() {
    final settings = Provider.of<AppSettingProvider>(context, listen: false);
    settings.setScrollSpeed(settings.getScrollSpeed + 1.0);
    _showSpeedLabel(settings.getScrollSpeed);
  }

  void _decreaseScrollSpeed() {
    final settings = Provider.of<AppSettingProvider>(context, listen: false);
    if (settings.getScrollSpeed > 1.0) {
      settings.setScrollSpeed(settings.getScrollSpeed - 1.0);
      _showSpeedLabel(settings.getScrollSpeed);
    }
  }

  void _togglePause() {
    final settings = Provider.of<AppSettingProvider>(context, listen: false);
    settings.togglePause();
  }

  void _showSpeedLabel(double speed) {
    setState(() => _speedLabel = speed.toStringAsFixed(1));
    Future.delayed(Duration(seconds: 1), () {
      setState(() => _speedLabel = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingProvider>(context);
    Color iconColor = settings.textColor;
    double buttonIconsSize = settings.buttonIconsSize;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_speedLabel != null)
            Text(
              _speedLabel!,
              style: TextStyle(fontSize: settings.fontSize, fontWeight: FontWeight.bold, color: iconColor),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.remove_circle_outline, size: buttonIconsSize, color: iconColor),
                onPressed: _decreaseScrollSpeed,
              ),
              IconButton(
                icon: Icon(settings.isPaused ? Icons.play_circle : Icons.pause_circle, size: buttonIconsSize, color: iconColor),
                onPressed: _togglePause,
              ),
              IconButton(
                icon: Icon(Icons.add_circle_outline, size: buttonIconsSize, color: iconColor),
                onPressed: _increaseScrollSpeed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
