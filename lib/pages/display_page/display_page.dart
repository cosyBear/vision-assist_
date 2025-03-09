import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:steady_eye_2/pages/display_page/wigdt/bookmark_manager.dart';
import 'package:steady_eye_2/pages/display_page/wigdt/scroll_controls.dart';
import 'package:steady_eye_2/pages/display_page/wigdt/scrolling_text_view.dart';
import '../../general/app_setting_provider.dart';
import '../../general/document_provider.dart';
import '../../general/navbar_with_return_button.dart';
import 'wigdt/draggable_button.dart';

class DisplayPage extends StatefulWidget {
  final String title;
  final String? documentName;

  const DisplayPage({super.key, required this.title, this.documentName});

  @override
  State<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  late double xPos;
  late double yPos;
  double textOffset = 0;

  late ScrollController _scrollController;
  double _bookmarkedPosition = 0.0;
  bool _isRestored = false; // Prevent multiple restores

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    // Check if documentName is not null and only restore bookmark when it's done loading
    if (widget.documentName != null) {
      final documentProvider = Provider.of<DocumentProvider>(context, listen: false);
      if (!documentProvider.loading) {
        _restoreBookmarkPosition(); // Restore bookmark if data is already loaded
      }
    }

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

  /// Restores only the last **bookmarked** position
  Future<void> _restoreBookmarkPosition() async {
    if (widget.documentName == null || _isRestored) return;

    final documentProvider = Provider.of<DocumentProvider>(context, listen: false);

    // Wait until loading is complete
    if (documentProvider.loading) return;  // Only proceed when the loading is finished

    List<double> bookmarks = await documentProvider.getBookmarks(widget.documentName!);

    if (bookmarks.isEmpty) return;  // Handle case when there are no bookmarks

    double savedPosition = bookmarks.last;  // Get the last saved bookmark position

    setState(() {
      _bookmarkedPosition = savedPosition;
    });

    // Ensure jumpTo() runs after the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_bookmarkedPosition);
        _isRestored = true; // Prevent multiple restores
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingProvider>(context, listen: false);
    final buttonSize = settings.fontSize * 2;

    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = settings.fontSize;
    double buttonIconsSize = settings.buttonIconsSize;

    if (screenWidth < 1000) {
      fontSize = settings.fontSize > 40 ? 40 : settings.fontSize;
      buttonIconsSize =
      settings.buttonIconsSize > 60 ? 60 : settings.buttonIconsSize;
    }

    return Scaffold(
      appBar: NavbarWithReturnButton(
          fontSize: fontSize, buttonIconsSize: buttonIconsSize),
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
                    scrollController: _scrollController, // Pass the controller
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

                        // Variable for storing the current y position
                        // of the button before it's clamped
                        double currentYPos = yPos;

                        // Clamp to keep the button in view
                        xPos = xPos.clamp(minX, maxX);
                        yPos = yPos.clamp(minY, maxY);

                        // Save new positions
                        settings.setXPos(xPos);
                        settings.setYPos(yPos);

                        // Adjust text offset based on button position
                        final textMiddleY = availableHeight / 2;
                        if (currentYPos > textMiddleY) {
                          textOffset = -60;
                        } else if (currentYPos < textMiddleY - 40) {
                          textOffset = 60;
                        }  else {
                          textOffset = 0;
                        }
                      });
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: BookmarkManager(
                      documentName: widget.documentName,
                      scrollController: _scrollController,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
