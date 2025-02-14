import 'package:flutter/material.dart';
import 'wigdt/upload_box.dart';
import 'wigdt/upload_text.dart';
import '../../general/app_setting_provider.dart';
import 'package:provider/provider.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true, // Ensures proper resizing with the keyboard
      backgroundColor: settings.backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0), // Optional: Adds padding on the sides
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centers the content vertically
            crossAxisAlignment: CrossAxisAlignment.center, // Ensures content is centered horizontally
            children: [
              // Text box should be centered vertically with the text below
              UploadBox(controller: _controller),
              const UploadText(),
            ],
          ),
        ),
      ),
    );
  }
}
