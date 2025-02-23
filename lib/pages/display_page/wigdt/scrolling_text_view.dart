import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../general/app_setting_provider.dart';

class ScrollingTextView extends StatefulWidget {
  final String text;
  final double textOffset;
  final ScrollController scrollController; // Add this line

  const ScrollingTextView({
    super.key,
    required this.text,
    required this.textOffset,
    required this.scrollController, // Add this line
  });

  @override
  _ScrollingTextViewState createState() => _ScrollingTextViewState();
}

class _ScrollingTextViewState extends State<ScrollingTextView> {
  late ScrollController _scrollController;
  Timer? _scrollTimer;
  bool _hasScrolledToEnd = false;
  bool _isShortText = false;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _determineTextType();
      _startScrollingAnimation();
    });
  }

  void _determineTextType() {
    final settings = Provider.of<AppSettingProvider>(context, listen: false);
    double textWidth = (widget.text.length * settings.fontSize) * 0.6;
    double screenWidth = MediaQuery.of(context).size.width;
    _isShortText = textWidth < screenWidth;
  }

  void _startScrollingAnimation() {
    _scrollTimer?.cancel();
    _scrollTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      final settings = Provider.of<AppSettingProvider>(context, listen: false);
      if (settings.isPaused || _hasScrolledToEnd) return;

      if (_scrollController.hasClients) {
        double maxScroll = _scrollController.position.maxScrollExtent;
        if (_scrollController.offset >= maxScroll) {
          _hasScrolledToEnd = true;
          timer.cancel(); // Stop scrolling when reaching the end
        } else {
          _scrollController.jumpTo(_scrollController.offset + settings.getScrollSpeed);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingProvider>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = screenWidth < 600 ? 400 : screenWidth;
    double startPadding = containerWidth;

    return Positioned(
      top: MediaQuery.of(context).size.height / 2 - 100 + widget.textOffset,
      left: 0,
      right: 0,
      child: SizedBox(
        width: containerWidth,
        height: settings.fontSize * 1.2,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          child: Row(
            children: [
              SizedBox(width: startPadding), // Start text off-screen
              Text(
                widget.text.replaceAll('\n', ' '),
                style: TextStyle(
                  color: settings.textColor,
                  fontSize: settings.fontSize,
                  fontFamily: settings.fontFamily,
                  fontWeight: settings.fontWeight,
                  decoration: TextDecoration.none,
                ),
              ),
              SizedBox(width: _isShortText ? screenWidth : containerWidth), // Ensure text fully exits screen
            ],
          ),
        ),
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
