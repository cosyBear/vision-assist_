import 'dart:async';
import 'package:flutter/material.dart';
import 'package:text_scroll/text_scroll.dart';

class ScrollingText extends StatefulWidget {
  final String title;

  const ScrollingText({super.key, required this.title});

  @override
  State<ScrollingText> createState() => _ScrollingTextState();
}

class _ScrollingTextState extends State<ScrollingText> {
  bool _shouldScroll = true; // Controls whether scrolling is active
  double _scrollSpeed = 50.0; // Default scroll speed

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateScrollSpeed();
    });
  }

  void _calculateScrollSpeed() {
    // Define text style
    TextStyle textStyle = const TextStyle(fontSize: 20);

    // Measure text width
    double textWidth = getTextWidth(widget.title, textStyle);

    // Define screen width limit
    double containerWidth = 600.0;

    // Calculate scroll distance (text width + screen width)
    double distanceToScroll = textWidth + containerWidth;

    // Define base scroll speed (pixels per second)
    double scrollSpeed = distanceToScroll / 5; // Adjust for readability

    // Ensure scrollSpeed is within limits
    if (scrollSpeed < 30) scrollSpeed = 30;
    if (scrollSpeed > 120) scrollSpeed = 120;

    // Update the state with the new scroll speed
    setState(() {
      _scrollSpeed = scrollSpeed;
    });

    // Calculate estimated scroll time in milliseconds
    int estimatedScrollTime = ((distanceToScroll / _scrollSpeed) * 1000).toInt();

    // Navigate back after scrolling finishes
    Timer(Duration(milliseconds: estimatedScrollTime), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  // Function to measure text width dynamically
  double getTextWidth(String text, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    return textPainter.width; // Returns actual text width
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _shouldScroll
                ? TextScroll(
              widget.title,
              textDirection: TextDirection.ltr,
              velocity: Velocity(pixelsPerSecond: Offset(_scrollSpeed, 0)),
              mode: TextScrollMode.endless,
              pauseBetween: Duration(milliseconds: 500), // Small pause for better readability
              style: const TextStyle(
                fontSize: 20,
                color: Colors.yellow,
                decoration: TextDecoration.underline,
              ),
            )
                : Text(
              widget.title,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.yellow,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
