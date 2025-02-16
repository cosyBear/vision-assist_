import 'package:flutter/material.dart';
import 'dart:ui'; // Import for window.physicalSize
import '../database/setting_box.dart'; // Import the settings box

class AppSettingProvider with ChangeNotifier {
  // Default settings
  Color _backgroundColor = Colors.red;
  Color _textColor = Colors.white;
  late double _fontSize;
  String _fontFamily = 'Roboto';
  FontWeight _fontWeight = FontWeight.normal;
  double _scrollSpeed = 2;
  bool _isPaused = false; // Track scrolling state

  // ✅ Load settings when the app starts
  AppSettingProvider() {
    _loadSettings();
  }

  Color get backgroundColor => _backgroundColor;

  double get fontSize => _fontSize;

  String get fontFamily => _fontFamily;

  FontWeight get fontWeight => _fontWeight;

  Color get textColor => _textColor;

  double get getScrollSpeed => _scrollSpeed;

  bool get isPaused => _isPaused; // Getter for pause state

  // ✅ Retrieve saved settings or use defaults
  void _loadSettings() {
    // Get screen width
    double screenWidth = window.physicalSize.width / window.devicePixelRatio;

    // Set default font size based on screen width
    _fontSize = screenWidth > 1000 ? 50 : 30;

    // Retrieve saved settings from Hive, if any; otherwise, use defaults
    _backgroundColor =
        SettingBox.getColorFromHive('backgroundColor', Colors.black);
    _textColor = SettingBox.getColorFromHive('textColor', Colors.white);
    _fontSize =
        SettingBox.getSetting('fontSize', _fontSize); // Use adjusted default
    _fontFamily = SettingBox.getSetting('fontFamily', 'Roboto');
    _fontWeight = _getFontWeightFromHive('fontWeight', FontWeight.normal);
    _scrollSpeed = SettingBox.getSetting('scrollSpeed', 2.0);

    // Notify listeners that settings have been loaded
    notifyListeners();
  }

  // ✅ Convert color from Hive (Hive saves Colors as int values)
  Color _getColorFromHive(String key, Color defaultColor) {
    int? colorValue = SettingBox.getSetting(key, null);
    return colorValue != null ? Color(colorValue) : defaultColor;
  }

  // ✅ Convert saved int value of FontWeight to FontWeight enum
  FontWeight _getFontWeightFromHive(String key, FontWeight defaultWeight) {
    int? weightIndex = SettingBox.getSetting(key, null);
    return weightIndex != null ? FontWeight.values[weightIndex] : defaultWeight;
  }

  // ✅ Save settings
  void setScrollSpeed(double speed) {
    _scrollSpeed = speed;
    SettingBox.saveSetting("scrollSpeed", speed);
    notifyListeners();
  }

  void togglePause() {
    _isPaused = !_isPaused;
    notifyListeners();
  }

  void setBackgroundColor(Color color) {
    _backgroundColor = color;
    SettingBox.saveSetting('backgroundColor', color.value);
    notifyListeners();
  }

  void setTextColor(Color color) {
    _textColor = color;
    SettingBox.saveSetting('textColor', color.value);
    notifyListeners();
  }

  void setFontSize(double size) {
    _fontSize = size;
    SettingBox.saveSetting('fontSize', size);
    notifyListeners();
  }

  void setFontFamily(String family) {
    _fontFamily = family;
    SettingBox.saveSetting('fontFamily', family);
    notifyListeners();
  }

  void setFontWeight(FontWeight weight) {
    _fontWeight = weight;
    SettingBox.saveSetting('fontWeight', weight.index);
    notifyListeners();
  }
}
