import 'package:flutter/material.dart';
import '../../../general/app_setting_provider.dart';

/*
  This class is a button that changes the font of the text. (Arial, Verdana, etc.)
  It uses the AppSettingProvider class.
 */
class FontButton extends StatelessWidget {
  final AppSettingProvider settings;
  final String label;
  final String fontFamily;
  final double fontSize;
  final int index;

  const FontButton({
    super.key,
    required this.settings,
    required this.label,
    required this.fontFamily,
    required this.fontSize,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    // Alternating colors based on index
    Color buttonBorder = (index % 2 == 0)
        ? const Color.fromRGBO(203, 105, 156, 1) // Pink
        : const Color.fromRGBO(22, 173, 201, 1); // Blue

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: settings.backgroundColor,
          side: BorderSide(color: buttonBorder, width: 3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
        onPressed: () {
          settings.setFontFamily(fontFamily);
        },
        child: Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            color: settings.textColor,
            fontFamily: fontFamily,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
