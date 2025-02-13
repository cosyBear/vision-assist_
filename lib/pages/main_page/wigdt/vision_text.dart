import 'package:flutter/material.dart';
import '../../../general/app_setting_provider.dart';

class VisionText extends StatelessWidget {
  final AppSettingProvider settings;
  final double screenWidth;
  const VisionText({super.key, required this.settings, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Vision",
          style: TextStyle(
            fontSize: screenWidth * 0.06,
            color: settings.textColor,
            fontFamily: settings.fontFamily,
          ),
        ),
        Text(
          "See Beyond\nThe Blind Spot",
          style: TextStyle(
            fontSize: screenWidth * 0.020,
            color: settings.textColor,
            fontFamily: settings.fontFamily,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
