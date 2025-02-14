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
    final viewInsets = MediaQuery.of(context).viewInsets; // Get keyboard's viewInsets
    double screenWidth = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true, // Ensures proper resizing with the keyboard
      backgroundColor: settings.backgroundColor,

      body: SingleChildScrollView( // Allow scrolling when the keyboard is up
        child: Padding(
          padding: EdgeInsets.all(30), // Adjust the padding based on the keyboard
          child: Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Keep content vertically centered
              crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
              children: [
                UploadBox(controller: _controller),
                UploadText(),

              ],
            ),
          ),
        ),
      ),
    );
  }
}