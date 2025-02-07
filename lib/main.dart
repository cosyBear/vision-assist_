import 'package:flutter/material.dart';
import 'MainScreen.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
  ]);
  runApp(MaterialApp(
      home: const MainScreen(),
  ));
}
