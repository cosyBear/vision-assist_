import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../general/app_setting_provider.dart';
/*
  This class displays the font size.
*/
class FontSizeDisplay extends StatelessWidget {
  final double fontSize;

  const FontSizeDisplay({super.key, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingProvider>(context);
    Color textColor = settings.textColor;
    double fontSize = settings.fontSize;
    return Text(
      fontSize.toStringAsFixed(1),
      style: TextStyle(fontSize: fontSize, color: textColor),
    );
  }
}
