import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:steady_eye_2/general/app_setting_provider.dart';
import 'package:steady_eye_2/pages/settings_page/widgt/settings_button.dart';
import '../font_page/font_page.dart';
import '../color_page/colors.dart';
import '../icon_button/icon_button.dart';
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

    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SettingsButton(
              text: "TEXT",
              page: TextSizeFonts(),
              settings: settings,
              borderColor: const Color.fromRGBO(203, 105, 156, 1),
            ),
            SettingsButton(
              text: "BUTTON",
              page: IconButtonSize(),
              settings: settings,
              borderColor: const Color.fromRGBO(203, 105, 156, 1),
            ),
            SettingsButton(
              text: "COLOR",
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