import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:steady_eye_2/pages/display_page/wigdt/scroll_controls.dart';
import 'package:steady_eye_2/pages/display_page/wigdt/scrolling_text_view.dart';
import 'wigdt/draggable_button.dart';
import 'dart:developer';

class DisplayPage extends StatefulWidget {
  final String title;

  const DisplayPage({super.key, required this.title});

  @override
  State<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  double xPos = 306;
  double yPos = 134;
  double textOffset = 0;
  bool hasBuilt = false;

  @override
  Widget build(BuildContext context) {
    log(xPos.toString());
    log(yPos.toString());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(18, 18, 18, 1.0),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: GradientText(
          "SteadyEye",
          style: const TextStyle(fontSize: 40),
          colors: const [
            Color.fromRGBO(203, 105, 156, 1.0),
            Color.fromRGBO(22, 173, 201, 1.0),
          ],
        ),
      ),
      body: Stack(
        children: [
          DraggableButton(
              xPos: xPos,
              yPos: yPos,
              onPositionChanged: (dx, dy) {
                setState(() {
                  xPos += dx;
                  yPos += dy;

                  if(hasBuilt) {
                    double screenHeight = MediaQuery.of(context).size.height;
                    double textMiddleY = screenHeight / 2;

                    if (yPos > textMiddleY + 20) {
                      textOffset = -20;
                    } else if (yPos < textMiddleY - 20) {
                      textOffset = 20;
                    } else {
                      textOffset = 0;
                    }
                  }
                });
                hasBuilt = true;
              }),
          ScrollingTextView(text: widget.title, textOffset: textOffset),
          ScrollControls(),
        ],
      ),
    );
  }
}

