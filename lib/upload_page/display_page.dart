import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:steady_eye_2/wigdt/app_setting_provider.dart';
import '../wigdt/scrolling_text.dart'; // Import the scrolling text widget

class DisplayPage extends StatefulWidget {
  final String text;

  const DisplayPage({super.key, required this.text});

  @override
  State<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  void _handleScrollEnd() {
    Navigator.pop(context); // ✅ Go back to the previous screen when text finishes
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Display Text"),
        backgroundColor: Colors.black,
      ),
      backgroundColor: settings.backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 100,
            child: ScrollingText(
              title: widget.text,
            ),
          ),
        ),
      ),
    );
  }
}
