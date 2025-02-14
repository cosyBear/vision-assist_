import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:steady_eye_2/pages/display_page/wigdt/scroll_controls.dart';
import 'package:steady_eye_2/pages/display_page/wigdt/scrolling_text_view.dart';
import 'wigdt/draggable_button.dart';

/*
  This is the main page of the display. It will display the text that was passed to it.
  It will also contain the focus point that the user can drag around the screen.
 */
class DisplayPage extends StatefulWidget {
  final String title;

  const DisplayPage({super.key, required this.title});

  @override
  State<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  late double xPos;
  late double yPos;
  double textOffset = 0;

  /*
  This will be called after the first frame is rendered.
  This is where we will set the initial position of the button.
   */
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      double screenWidth = MediaQuery.of(context).size.width;
      double screenHeight = MediaQuery.of(context).size.height;

      // 30 is half the size of the button (see draggable_button.dart)
      setState(() {
        xPos = (screenWidth / 2) - 30;
        yPos = (screenHeight / 2) - 30;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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

