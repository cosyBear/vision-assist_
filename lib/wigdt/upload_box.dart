import 'package:flutter/material.dart';
import 'app_setting_provider.dart';
import 'package:provider/provider.dart';
import '../pages/display_page.dart';
import 'dart:developer';

class UploadBox extends StatelessWidget {
  final TextEditingController controller;
  final ScrollController _scrollController = ScrollController();

  UploadBox({super.key, required this.controller});

  void _sendMessage(BuildContext context) {
    String text = controller.text.trim();
    if (text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScrollingText(title: text),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Container(
        width: 700,
        height: 150,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: TextField(
                      controller: controller,
                      maxLines: null,
                      // Allows unlimited input
                      keyboardType: TextInputType.multiline,
                      // Multi-line input
                      style: TextStyle(fontSize: 30, color: settings.textColor),
                      decoration: const InputDecoration(
                        hintText: "Enter text...",
                        border: InputBorder.none, // Remove default border
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50), // Space for icons
              ],
            ),
            Positioned(
              left: -15,
              bottom: -5,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.attach_file,
                        color: Colors.grey[600], size: 30),
                    onPressed: () => log("File uploaded"),
                  ),
                  IconButton(
                    icon: Icon(Icons.camera_alt,
                        color: Colors.grey[600], size: 30),
                    onPressed: () => log("Picture taken"),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: -5,
              right: -5,
              child: ElevatedButton(
                onPressed: () {
                  print('Button Pressed!');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // White background
                  side: BorderSide(color: Colors.purple, width: 2), // Purple border
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                  minimumSize: Size(200, 60), // Custom size (width: 200, height: 60)
                ),
                child: Text(
                  'Send',
                  style: TextStyle(color: Colors.purple, fontSize: 18), // Purple text with larger font
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
