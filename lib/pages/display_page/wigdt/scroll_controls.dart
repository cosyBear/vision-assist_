import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../general/app_setting_provider.dart';

class ScrollControls extends StatefulWidget {
  @override
  _ScrollControlsState createState() => _ScrollControlsState();
}

class _ScrollControlsState extends State<ScrollControls> {
  bool _isPaused = false;
  double _scrollSpeed = 1.0;
  String? _speedLabel;

  void _increaseScrollSpeed() {
    setState(() {
      _scrollSpeed += 1.0;
      _speedLabel = _scrollSpeed.toStringAsFixed(1);
    });

    Future.delayed(Duration(seconds: 1), () {
      setState(() => _speedLabel = null);
    });
  }

  void _decreaseScrollSpeed() {
    setState(() {
      if (_scrollSpeed > 1.0) _scrollSpeed -= 1.0;
      _speedLabel = _scrollSpeed.toStringAsFixed(1);
    });

    Future.delayed(Duration(seconds: 1), () {
      setState(() => _speedLabel = null);
    });
  }

  void _togglePause() {
    setState(() => _isPaused = !_isPaused);
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingProvider>(context);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_speedLabel != null)
            Text(
              _speedLabel!,
              style: TextStyle(fontSize: settings.fontSize, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(icon: Icon(Icons.remove_circle_outline, size: 50, color: Colors.grey), onPressed: _decreaseScrollSpeed),
              IconButton(icon: Icon(_isPaused ? Icons.play_circle : Icons.pause_circle, size: 50, color: Colors.grey), onPressed: _togglePause),
              IconButton(icon: Icon(Icons.add_circle_outline, size: 50, color: Colors.grey), onPressed: _increaseScrollSpeed),
            ],
          ),
        ],
      ),
    );
  }
}
