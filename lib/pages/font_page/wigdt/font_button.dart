

import 'package:flutter/material.dart';
import '../../../general/app_setting_provider.dart';
import 'package:provider/provider.dart';

/*
class FontButton extends StatefulWidget {
  const FontButton({super.key});

  @override
  State<FontButton> createState() => _FontButtonState();
}

class _FontButtonState extends State<FontButton> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
Widget _buildFontButton(AppSettingProvider settings, String label,
    String fontFamily, double fontSize, int index) {
  // Alternating colors based on index
  Color buttonBorder = (index % 2 == 0)
      ? const Color.fromRGBO(203, 105, 156, 1) // Pink
      : const Color.fromRGBO(22, 173, 201, 1); // Blue

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5.0),
    child: TextButton(
      style: TextButton.styleFrom(
        backgroundColor: settings.backgroundColor,
        side: BorderSide(color: buttonBorder, width: 1.5),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
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
        ),
      ),
    ),
  );
}*/