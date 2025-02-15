import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:steady_eye_2/pages/display_page/wigdt/scroll_controls.dart';
import 'package:steady_eye_2/pages/display_page/wigdt/scrolling_text_view.dart';
import '../../general/app_setting_provider.dart';
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
  This method will be called after the first frame is rendered.
  This is where we will set the initial position of the button.
   */
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      double screenWidth = MediaQuery.of(context).size.width;
      double screenHeight = MediaQuery.of(context).size.height;

      final settings = Provider.of<AppSettingProvider>(context, listen: false);
      double buttonSize = settings.fontSize * 2; // Button size is twice the font size

      setState(() {
        if (settings.xPos != 0 && settings.yPos != 0) {
          xPos = settings.xPos;
          yPos = settings.yPos;
        } else {
          // Center the button if the user has not set a position
          xPos = (screenWidth / 2) - (buttonSize / 2);
          yPos = (screenHeight / 2) - (buttonSize / 2);
          settings.setXPos(xPos);
          settings.setYPos(yPos);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingProvider>(context, listen: false);
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

                  settings.setXPos(xPos);
                  settings.setYPos(yPos);

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

