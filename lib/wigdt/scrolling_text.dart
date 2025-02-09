import 'dart:async';
import 'package:flutter/material.dart';
import 'package:text_scroll/text_scroll.dart';
import '../wigdt/app_setting_provider.dart';
import 'package:provider/provider.dart';

class ScrollingText extends StatefulWidget {
  final String title;

  const ScrollingText({super.key, required this.title});

  @override
  State<ScrollingText> createState() => _ScrollingTextState();
}

class _ScrollingTextState extends State<ScrollingText> {
  bool _shouldScroll = true;

  // ✅ Function to measure text width dynamically
  double getTextWidth(String text, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style), // Apply text style
      maxLines: 1, // Single line text
      textDirection: TextDirection.ltr, // Left to right direction
    )..layout(); // Calculate width

    return textPainter.width; // Get the measured width
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingProvider>(context);

    // ✅ Get scroll speed from provider or default to 50
    double scrollSpeed = 50.0;

    // ✅ Get container width from provider or default to 400
    int containerWidth = 400;

    // ✅ Dynamically measure text width
    double textWidth = getTextWidth(
      widget.title,
      TextStyle(
        fontSize: settings.fontSize,
        fontFamily: settings.fontFamily,
        fontWeight: settings.fontWeight,
      ),
    );

    // ✅ Calculate total scroll distance
    double distanceToScroll = textWidth + containerWidth;

    // ✅ Calculate estimated scroll time (convert to milliseconds)
    int estimatedScrollTime = ((distanceToScroll / scrollSpeed) * 1000).toInt();

    // ✅ Stop scrolling after the estimated time
    Timer(Duration(milliseconds: estimatedScrollTime), () {
      setState(() {
        _shouldScroll = false; // Stop scrolling
      });
    });

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: containerWidth.toDouble()),
        // Use dynamic width
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _shouldScroll
                ? TextScroll(
                    widget.title,
                    textDirection: TextDirection.ltr,
                    velocity: Velocity(pixelsPerSecond: Offset(scrollSpeed, 0)),
                    // ✅ Use dynamic scroll speed
                    style: TextStyle(
                      color: settings.textColor,
                      fontSize: settings.fontSize,
                      fontFamily: settings.fontFamily,
                      fontWeight: settings.fontWeight,
                    ),
                  )
                : Text(
                    widget.title,
                    style: TextStyle(
                      color: settings.textColor,
                      fontSize: settings.fontSize,
                      fontFamily: settings.fontFamily,
                      fontWeight: settings.fontWeight,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
