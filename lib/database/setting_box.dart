import 'dart:ui';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';

class SettingBox {
  static late Box settingsBox;

  // Open settings box when the app starts
  static Future<void> init() async {
    settingsBox = await Hive.openBox('settings');

    // Get screen width

    //for tablet and desktop, we need a bigger default font size
    // Get screen width correctly using PlatformDispatcher
    double screenWidth = PlatformDispatcher.instance.views.first.physicalSize.width /
        PlatformDispatcher.instance.views.first.devicePixelRatio;
    double defaultFontSize = screenWidth > 1000 ? 50 : 30;

    // Check if keys exist, if not, set default values only on the first launch
    if (!settingsBox.containsKey('backgroundColor')) {
      settingsBox.put('backgroundColor', Colors.black.value);
    }
    if (!settingsBox.containsKey('textColor')) {
      settingsBox.put('textColor', Colors.white.value);
    }
    if (!settingsBox.containsKey('fontSize')) {
      settingsBox.put('fontSize', defaultFontSize); // Use adjusted default
    }
    if (!settingsBox.containsKey('fontFamily')) {
      settingsBox.put('fontFamily', 'Inria Serif');
    }
    if (!settingsBox.containsKey('fontWeight')) {
      settingsBox.put('fontWeight', FontWeight.normal.index);
    }
    if (!settingsBox.containsKey('scrollSpeed')) {
      settingsBox.put('scrollSpeed', 2.0);
    }
    if(!settingsBox.containsKey('buttonIconsSize')){
      settingsBox.put('buttonIconsSize', 40);
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
