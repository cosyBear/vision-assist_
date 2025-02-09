import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';

class SettingBox {
  static late Box settingsBox;

  // Open settings box when the app starts
  static Future<void> init() async {
    settingsBox = await Hive.openBox('settings');

    // Check if keys exist, if not, set default values only on the first launch
    if (!settingsBox.containsKey('backgroundColor')) {
      settingsBox.put('backgroundColor', Colors.black.value); // Store as int (ARGB value)
    }
    if (!settingsBox.containsKey('textColor')) {
      settingsBox.put('textColor', Colors.white.value); // Store as int (ARGB value)
    }
    if (!settingsBox.containsKey('fontSize')) {
      settingsBox.put('fontSize', 20.0); // Default font size
    }
    if (!settingsBox.containsKey('fontFamily')) {
      settingsBox.put('fontFamily', 'Inria Serif'); // Default font family
    }
    if (!settingsBox.containsKey('fontWeight')) {
      settingsBox.put('fontWeight', FontWeight.normal.index); // Store as index
    }
  }

  // Save and retrieve settings
  static void saveSetting(String key, dynamic value) {
    settingsBox.put(key, value);
  }

  static dynamic getSetting(String key, dynamic defaultValue) {
    return settingsBox.get(key, defaultValue: defaultValue);
  }

  // Convert color from int value stored in Hive back to Color
  static Color getColorFromHive(String key, Color defaultColor) {
    int? colorValue = settingsBox.get(key, defaultValue: null);
    return colorValue != null ? Color(colorValue) : defaultColor;
  }
}
