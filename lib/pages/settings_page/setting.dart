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
            // Gradient border for the button
            Container(
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color.fromRGBO(203, 105, 156, 1.0), // Pink on the left
                    Color.fromRGBO(22, 173, 201, 1.0), // Blue on the right
                  ],
                ),
                borderRadius: BorderRadius.circular(50.0), // Matches button shape
              ),
              child: Container(
                decoration: BoxDecoration(
                  // color: Colors.white, // Background color inside the border
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SettingsButton(
                  text: "BUTTON",
                  page: IconButtonSize(),
                  settings: settings,
                  borderColor: Colors.transparent, // Transparent since border is external
                ),
              ),
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
