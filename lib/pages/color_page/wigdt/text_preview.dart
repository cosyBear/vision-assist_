import 'package:flutter/material.dart';

/*
  This class is a preview of the text that will be displayed in the TextSizeFonts page.
  It is used to show the user how the text will look like with the selected font and size.
 */
class TextPreview extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color backgroundColor;
  final double fontSize;
  final double previewBoxSize;

  const TextPreview({
    super.key,
    required this.text,
    required this.textColor,
    required this.backgroundColor,
    required this.fontSize,
    required this.previewBoxSize,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = backgroundColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
    return Container(
      width: previewBoxSize,
      height: previewBoxSize,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Center(
        child: FittedBox(
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
