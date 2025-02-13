import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../general/app_setting_provider.dart';

class ScrollingTextView extends StatefulWidget {
  final String text;
  final double textOffset;

  const ScrollingTextView({super.key, required this.text, required this.textOffset});

  @override
  _ScrollingTextViewState createState() => _ScrollingTextViewState();
}

class _ScrollingTextViewState extends State<ScrollingTextView> {
  bool _shouldScroll = true;
  bool _hasScrolledToEnd = false;
  late ScrollController _scrollController;
  late double _scrollSpeed;
  Timer? _scrollTimer;

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

  void _startScrollingAnimation() {
    _scrollTimer?.cancel();
    _scrollTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      final settings = Provider.of<AppSettingProvider>(context, listen: false);

      if (settings.isPaused || _hasScrolledToEnd) {
        // If paused, stop the scroll
        return;
      }

      if (_scrollController.hasClients) {
        double maxScroll = _scrollController.position.maxScrollExtent;
        if (_scrollController.offset >= maxScroll) {
          _scrollController.jumpTo(maxScroll);
          _shouldScroll = false;
          _hasScrolledToEnd = true;
          timer.cancel();
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
    double containerWidth = screenWidth < 600 ? 400 : screenWidth * 0.8;

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
              const SizedBox(width: 16), // Add padding before the text
              Text(
                widget.text,
                style: TextStyle(
                  color: settings.textColor,
                  fontSize: settings.fontSize,
                  fontFamily: settings.fontFamily,
                  fontWeight: settings.fontWeight,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(width: 16), // Add padding after the text
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
