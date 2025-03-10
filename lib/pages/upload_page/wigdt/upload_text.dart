import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../general/app_setting_provider.dart';
import 'package:provider/provider.dart';
import 'package:steady_eye_2/general/app_localizations.dart';

class UploadText extends StatelessWidget {
  const UploadText({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingProvider>(context);
    double screenWidth = MediaQuery.of(context).size.width;

    // Set the font size based on the screen width and settings
    double fontSize = settings.fontSize;

    // If screen width is less than 1000, adjust the font size
    if (screenWidth < 1000) {
      fontSize = settings.fontSize > 40 ? 40 : settings.fontSize;
    }

    return Padding(
      padding:  EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Text(
        context.tr('uploadText'),
        style: TextStyle(
          fontSize: fontSize, // Use the calculated font size
          fontWeight: FontWeight.bold,
          color: settings.textColor,
          fontFamily: settings.fontFamily,
        ),
      ),
    );
  }
}
