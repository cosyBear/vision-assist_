import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:steady_eye_2/general/app_setting_provider.dart';
import 'package:steady_eye_2/pages/settings_page/widgt/settings_button.dart';
import '../font_page/text_size_fonts.dart';
import '../color_page/colors.dart';

/*
  This class is the main page for the settings.
  It contains two buttons that will navigate to the TextSizeFonts and BackGroundTextColor pages.
  It uses the SettingsButton class.
 */
class GlobalSetting extends StatelessWidget {
  const GlobalSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingProvider>(context, listen: false);
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SettingsButton(
              text: "TEXT SIZE\n &\n FONTS",
              page: TextSizeFonts(),
              settings: settings,
              borderColor: const Color.fromRGBO(203, 105, 156, 1),
            ),
            Image.asset(
              'assets/images/logo.png',
              width: screenWidth * 0.2,
              height: screenWidth * 0.2,
            ),
            SettingsButton(
              text: "BACKGROUND\n&\n TEXT COLOR",
              page: BackGroundTextColor(),
              settings: settings,
              borderColor: const Color.fromRGBO(22, 173, 201, 1),
            ),
          ],
        ),
      ),
    );
  }
}