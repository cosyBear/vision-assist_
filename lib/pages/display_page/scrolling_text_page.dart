import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../general/app_setting_provider.dart';

class ScrollingText extends StatefulWidget {
  final String title;

  const ScrollingText({super.key, required this.title});

  @override
  State<ScrollingText> createState() => _ScrollingTextState();
}

class _ScrollingTextState extends State<ScrollingText> {
  bool _shouldScroll = true;
  bool _isPaused = false;
  bool _hasScrolledToEnd = false;
  late ScrollController _scrollController;
  double _scrollPosition = 0.0;
  late double _scrollSpeed;
  Timer? _scrollTimer;
  String? _speedLabel;

  double xPos = 200; // Draggable button X position
  double yPos = 200; // Draggable button Y position
  double textOffset = 0; // Offset for adjusting text position

  @override
  void initState() {
    super.initState();
    final settings = Provider.of<AppSettingProvider>(context, listen: false);
    _scrollSpeed = settings.getScrollSpeed;
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startScrollingAnimation();
    });
  }

  /// **Smooth scrolling animation (stops at end)**
  void _startScrollingAnimation() {
    _scrollTimer?.cancel();

    _scrollTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (_shouldScroll && !_isPaused && !_hasScrolledToEnd) {
        if (_scrollController.hasClients) {
          _scrollPosition += _scrollSpeed;

          double maxScroll = _scrollController.position.maxScrollExtent;

          if (_scrollPosition >= maxScroll) {
            _scrollController.jumpTo(maxScroll); // Ensure last part is visible
            _scrollPosition = maxScroll;
            _shouldScroll = false;
            _hasScrolledToEnd = true; // Mark scrolling as done
            timer.cancel();
          } else {
            _scrollController.jumpTo(_scrollPosition);
          }
        }
      }
    });
  }

  /// **Detect if the button is above or below the text and move text slightly**
  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      xPos += details.delta.dx;
      yPos += details.delta.dy;

      // Get screen size and middle position of text
      double screenHeight = MediaQuery.of(context).size.height;
      double textMiddleY = screenHeight / 2;

      // **Move text slightly up or down based on button's position**
      if (yPos > textMiddleY + 20) {
        textOffset = -20; // Move text UP if button is below
      } else if (yPos < textMiddleY - 20) {
        textOffset = 20; // Move text DOWN if button is above
      } else {
        textOffset = 0; // Keep text at normal position
      }
    });
  }

  /// **Increase Speed**
  void _increaseScrollSpeed() {
    setState(() {
      _scrollSpeed += 1.0;
      _shouldScroll = true;
      _speedLabel = '${_scrollSpeed.toStringAsFixed(1)}';
    });

    _startScrollingAnimation();

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _speedLabel = null;
      });
    });
  }

  /// **Decrease Speed**
  void _decreaseScrollSpeed() {
    setState(() {
      if (_scrollSpeed > 1.0) {
        _scrollSpeed -= 1.0;
        _shouldScroll = true;
        _speedLabel = '${_scrollSpeed.toStringAsFixed(1)}';
      }
    });

    _startScrollingAnimation();

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _speedLabel = null;
      });
    });
  }

  /// **Pause/Resume**
  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });

    if (!_isPaused) {
      _startScrollingAnimation();
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingProvider>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = screenWidth < 600 ? 400 : screenWidth * 0.8;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(18, 18, 18, 1.0),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          // **Draggable using GestureDetector**
          Positioned(
            left: xPos,
            top: yPos,
            child: GestureDetector(
              onPanUpdate: _onDragUpdate,
              child: Icon(Icons.add_circle, color: Colors.white, size: 50),
            ),
          ),

          // **Smooth Scrolling Text (Moves up/down based on draggable position)**
          Positioned(
            top: MediaQuery.of(context).size.height / 2 - 100 + textOffset, // Move based on button
            left: 0,
            right: 0,
            child: SizedBox(
              width: containerWidth,
              height: settings.fontSize * 1.2,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                child: Align(
                  alignment: Alignment.topCenter, // Ensures final part is visible

                  child: Text(
                    widget.title, // No repeating, just the full text
                    style: TextStyle(
                      color: settings.textColor,
                      fontSize: settings.fontSize,
                      fontFamily: settings.fontFamily,
                      fontWeight: settings.fontWeight,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // **Speed Controls (+ / -) & Pause**
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_speedLabel != null)
                    Text(
                      _speedLabel!,
                      style: TextStyle(
                        fontSize: settings.fontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove_circle_outline, color: Colors.grey, size: 50),
                        onPressed: () {
                          _decreaseScrollSpeed();
                          settings.setScrollSpeed(_scrollSpeed);
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          _isPaused ? Icons.play_circle_filled : Icons.pause_circle_filled,
                          size: 50,
                          color: Colors.grey,
                        ),
                        onPressed: _togglePause,
                      ),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline_sharp, size: 50, color: Colors.grey),
                        onPressed: () {
                          _increaseScrollSpeed();
                          settings.setScrollSpeed(_scrollSpeed);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollTimer?.cancel();
    super.dispose();
  }
}
