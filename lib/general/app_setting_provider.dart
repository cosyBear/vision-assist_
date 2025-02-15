import 'package:flutter/material.dart';
import '../database/setting_box.dart'; // Import the settings box

class AppSettingProvider with ChangeNotifier {
  // Default settings
  Color _backgroundColor = Colors.red;
  Color _textColor = Colors.white;
  double _fontSize = 20;
  String _fontFamily = 'Roboto';
  FontWeight _fontWeight = FontWeight.normal;
  double _scrollSpeed = 2;
  bool _isPaused = false; // Track scrolling state
  double _xPos = 0; // Track x position of the focus point
  double _yPos = 0; // Track y position of the focus point
  double _buttonIconsSize = 40; // Default size for button icons

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
  double get xPos => _xPos;
  double get yPos => _yPos;
  double get buttonIconsSize => _buttonIconsSize; // Getter for button icons size

  // ✅ Retrieve saved settings or use defaults
  void _loadSettings() {
    // Retrieve saved settings from Hive, if any; otherwise, use defaults
    _backgroundColor = SettingBox.getColorFromHive('backgroundColor', Colors.red); // Default color: red
    _textColor = SettingBox.getColorFromHive('textColor', Colors.white); // Default text color: white
    _fontSize = SettingBox.getSetting('fontSize', 20.0); // Default font size: 20
    _fontFamily = SettingBox.getSetting('fontFamily', 'Roboto'); // Default font: Roboto
    _fontWeight = _getFontWeightFromHive('fontWeight', FontWeight.normal); // Default font weight: normal
    _scrollSpeed = SettingBox.getSetting('scrollSpeed', 2.0); // Default scroll speed: 2
    _xPos = SettingBox.getSetting('xPos', 0.0); // Default x position: 0
    _yPos = SettingBox.getSetting('yPos', 0.0); // Default y position: 0
    _buttonIconsSize = SettingBox.getSetting("buttonIconsSize", 40.0).toDouble(); // ✅ Fix type error
    // Notify listeners that settings have been loaded
    notifyListeners();
  }


  void setButtonIconsSize(double size) {
    _buttonIconsSize = size;
    SettingBox.saveSetting('buttonIconsSize', size); // Save to storage
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
    _isPaused = !_isPaused; // Toggle pause state
    notifyListeners();
  }

  void setBackgroundColor(Color color) {
    _backgroundColor = color;
    SettingBox.saveSetting('backgroundColor', color.value); // Store as int value
    notifyListeners();
  }

  void setTextColor(Color color) {
    _textColor = color;
    SettingBox.saveSetting('textColor', color.value); // Store as int value
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
    SettingBox.saveSetting('fontWeight', weight.index); // Store as index value
    notifyListeners();
  }

  void setXPos(double x) {
    _xPos = x;
    SettingBox.saveSetting('xPos', x);
    notifyListeners();
  }

  void setYPos(double y) {
    _yPos = y;
    SettingBox.saveSetting('yPos', y);
    notifyListeners();
  }
}
