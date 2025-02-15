import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:steady_eye_2/pages/display_page/wigdt/scroll_controls.dart';
import 'package:steady_eye_2/pages/display_page/wigdt/scrolling_text_view.dart';
import '../../general/app_setting_provider.dart';
import 'wigdt/draggable_button.dart';

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;

      final settings = Provider.of<AppSettingProvider>(context, listen: false);
      final buttonSize = settings.fontSize * 2;

      setState(() {
        // If we already have saved positions, use them. Otherwise center the button.
        if (settings.xPos != 0 && settings.yPos != 0) {
          xPos = settings.xPos;
          yPos = settings.yPos;
        } else {
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
    final buttonSize = settings.fontSize * 2;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(18, 18, 18, 1.0),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.grey),
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
      body: SafeArea(
        // Use LayoutBuilder to get the actual available size
        child: LayoutBuilder(
          builder: (context, constraints) {
            // These are the *real* width and height of the SafeArea (below AppBar)
            final availableWidth = constraints.maxWidth;
            final availableHeight = constraints.maxHeight;

            return Stack(
              children: [
                // 1) Scrolling text
                Positioned.fill(
                  child: ScrollingTextView(
                    text: widget.title,
                    textOffset: textOffset,
                  ),
                ),

                // 2) Scroll controls at bottom-center
                ScrollControls(),

                // 3) Draggable button
                Positioned(
                  left: xPos,
                  top: yPos,
                  child: DraggableButton(
                    xPos: xPos,
                    yPos: yPos,
                    onPositionChanged: (dx, dy) {
                      setState(() {
                        // Update positions
                        xPos += dx;
                        yPos += dy;

                        // Calculate boundaries based on the actual layout size
                        final minX = 0.0;
                        final maxX = availableWidth - buttonSize;
                        final minY = 0.0;
                        final maxY = availableHeight - buttonSize;

                        // Clamp to keep the button in view
                        xPos = xPos.clamp(minX, maxX);
                        yPos = yPos.clamp(minY, maxY);

                        // Save new positions
                        settings.setXPos(xPos);
                        settings.setYPos(yPos);

                        // Adjust text offset based on button position
                        final textMiddleY = availableHeight / 2;
                        if (yPos > textMiddleY + 20) {
                          textOffset = -20;
                        } else if (yPos < textMiddleY - 20) {
                          textOffset = 20;
                        } else {
                          textOffset = 0;
                        }
                      });
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
