import 'package:flutter/material.dart';
import '../../../general/app_setting_provider.dart';

/*
  This class is a button that will navigate to the TextSizeFonts and BackGroundTextColor pages.
  It is used in the GlobalSetting class.
 */
class SettingsButton extends StatelessWidget {
  final String text;
  final Widget page;
  final AppSettingProvider settings;
  final Color borderColor;

  const SettingsButton({
    super.key,
    required this.text,
    required this.page,
    required this.settings,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth * 0.25,
      height: screenWidth * 0.2,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: settings.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
            side: BorderSide(
              color: borderColor,
              width: 1.0,
            ),
          ),
        ),
        child: FittedBox(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: settings.fontSize,
              fontFamily: settings.fontFamily,
              color: settings.textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
