import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import '../wigdt/app_setting_provider.dart';

class ScrollingText extends StatefulWidget {
  final String title;

  const ScrollingText({super.key, required this.title});

  @override
  State<ScrollingText> createState() => _ScrollingTextState();
}

class _ScrollingTextState extends State<ScrollingText> {
  bool _shouldScroll = true;
  bool _isPaused = false;
  late ScrollController _scrollController;
  double _scrollPosition = 0.0;
  late double _scrollSpeed;
  Timer? _scrollTimer;
  String? _speedLabel;

  @override
  void initState() {
    super.initState();
    final settings = Provider.of<AppSettingProvider>(context, listen: false);
    _scrollSpeed = settings.scrollSpeed;
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateScrollTime();
    });
  }

  void _calculateScrollTime() {
    final settings = Provider.of<AppSettingProvider>(context, listen: false);

    double screenWidth = MediaQuery.of(context).size.width;
    num containerWidth = screenWidth < 600 ? 400 : screenWidth * 0.8;

    TextStyle textStyle = TextStyle(
      fontSize: settings.fontSize,
      fontFamily: settings.fontFamily,
      fontWeight: settings.fontWeight,
    );

    double textWidth = getTextWidth(widget.title, textStyle);
    double distanceToScroll = textWidth + containerWidth;

    int estimatedScrollTime =
        ((distanceToScroll / _scrollSpeed) * 1000).toInt();

    Timer(Duration(milliseconds: estimatedScrollTime), () {
      if (mounted) {
        setState(() {
          _shouldScroll = false;
        });
      }
    });

    startScrolling();
  }

  void startScrolling() {
    _scrollTimer?.cancel();
    _scrollTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (_shouldScroll && !_isPaused) {
        setState(() {
          _scrollPosition += _scrollSpeed;
        });

        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollPosition);
        }
      } else {
        timer.cancel();
      }
    });
  }

  void increaseScrollSpeed() {
    setState(() {
      _scrollSpeed += 0.5;
      _shouldScroll = true;
      _scrollPosition = 0.0;
      _speedLabel = '${_scrollSpeed.toStringAsFixed(1)}';
    });

    _calculateScrollTime();

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _speedLabel = null;
      });
    });
  }

  void _decreaseScrollSpeed() {
    setState(() {
      if (_scrollSpeed > 1.0) {
        _scrollSpeed -= 0.5;
        _shouldScroll = true;
        _scrollPosition = 0.0;
        _speedLabel = '${_scrollSpeed.toStringAsFixed(1)}';
      }
    });

    _calculateScrollTime();

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _speedLabel = null;
      });
    });
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });

    if (!_isPaused) {
      startScrolling();
    }
  }

  double getTextWidth(String text, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    return textPainter.width;
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingProvider>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = screenWidth < 600 ? 400 : screenWidth * 0.8;
    _scrollSpeed = settings.scrollSpeed;

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
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: containerWidth,
                  height: settings.fontSize * 1.2,
                  child: _shouldScroll
                      ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _scrollController,
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        color: settings.textColor,
                        fontSize: settings.fontSize,
                        fontFamily: settings.fontFamily,
                        fontWeight: settings.fontWeight,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  )
                      : Text(
                    widget.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: settings.textColor,
                      fontSize: settings.fontSize,
                      fontFamily: settings.fontFamily,
                      fontWeight: settings.fontWeight,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),

          // Aligning the speed label just above the play/pause button row
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Place the speed label above the buttons
                  if (_speedLabel != null)
                    Text(
                      _speedLabel!,
                      style: TextStyle(
                        fontSize: settings.fontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  SizedBox(height: 10), // Space between label and buttons

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove_circle_outline,
                            color: Colors.grey, size: 50),
                        onPressed: () {
                          _decreaseScrollSpeed();
                          settings.setScrollSpeed(_scrollSpeed);
                        },
                        tooltip: 'Decrease Scroll Speed',
                      ),
                      IconButton(
                        icon: Icon(
                          _isPaused
                              ? Icons.play_circle_filled
                              : Icons.pause_circle_filled,
                          size: 50,
                          color: Colors.grey,
                        ),
                        onPressed: _togglePause,
                        tooltip:
                        _isPaused ? 'Resume Scrolling' : 'Pause Scrolling',
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.add_circle_outline_sharp,
                          size: 50,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          increaseScrollSpeed();
                          settings.setScrollSpeed(_scrollSpeed);
                        },
                      )
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
