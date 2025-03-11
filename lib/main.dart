import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'general/app_localizations.dart';
import 'general/document_provider.dart';
import 'general/language_provider.dart';
import 'general/main_screen.dart';
import 'general/app_setting_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'database/setting_box.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // ✅ Add this import

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
  ]);

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  await Hive.initFlutter();
  await SettingBox.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppSettingProvider()),
        ChangeNotifierProvider(create: (context) => DocumentProvider()),
        ChangeNotifierProvider(create: (context) => LanguageProvider()), // ✅ Add LanguageProvider
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Colors.black),
      locale: languageProvider.locale, // ✅ Apply selected language
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('nl', 'NL'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate, // ✅ Custom translation delegate
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const MainScreen(),
    );
  }
}
