import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'general/main_screen.dart';
import 'general/app_setting_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'database/setting_box.dart'; // Import the settings box
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
  ]);
  await Hive.initFlutter(); // Initialize Hive storage
  await SettingBox.init(); // Open settings box before app starts

  runApp(
    ChangeNotifierProvider(
      create: (context) => AppSettingProvider(), // Provides settings globally
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettingProvider>(
      builder: (context, settings, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: settings.backgroundColor, // Dynamic background
          ),
          home: const MainScreen(),
        );
      },
    );
  }
}
