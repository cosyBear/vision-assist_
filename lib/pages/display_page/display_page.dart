import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:steady_eye_2/pages/display_page/wigdt/scroll_controls.dart';
import 'package:steady_eye_2/pages/display_page/wigdt/scrolling_text_view.dart';

import '../../general/app_setting_provider.dart';
import 'wigdt/draggable_button.dart';

class ScrollingText extends StatefulWidget {
  final String title;
  const ScrollingText({super.key, required this.title});

  @override
  State<ScrollingText> createState() => _ScrollingTextState();
}

class _ScrollingTextState extends State<ScrollingText> {
  double xPos = 200;
  double yPos = 200;
  double textOffset = 0;

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(18, 18, 18, 1.0),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          DraggableButton(xPos: xPos, yPos: yPos, onPositionChanged: (dx, dy) {
            setState(() {
              xPos += dx;
              yPos += dy;

              double screenHeight = MediaQuery.of(context).size.height;
              double textMiddleY = screenHeight / 2;

              if (yPos > textMiddleY + 20) {
                textOffset = -20;
              } else if (yPos < textMiddleY - 20) {
                textOffset = 20;
              } else {
                textOffset = 0;
              }
            });
          }),
          ScrollingTextView(text: widget.title, textOffset: textOffset),
          ScrollControls(),
        ],
      ),
    );
  }
}
