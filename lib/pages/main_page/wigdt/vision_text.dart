import 'package:flutter/material.dart';
import '../../../general/app_setting_provider.dart';

class VisionText extends StatelessWidget {
  final AppSettingProvider settings;
  final double screenWidth;
  const VisionText({super.key, required this.settings, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Vision",
            style: TextStyle(
              fontSize: settings.fontSize * 1.5,
              color: settings.textColor,
              fontFamily: settings.fontFamily,
            ),
          ),
          Text(
            "See Beyond\nThe Blind Spot",
            style: TextStyle(
              fontSize: settings.fontSize,
              color: settings.textColor,
              fontFamily: settings.fontFamily,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
