import 'package:flutter/material.dart';
import '../../../general/app_setting_provider.dart';
import 'package:provider/provider.dart';
import 'dart:developer';
import '../../display_page/display_page.dart';

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
          builder: (context) => DisplayPage(title: text),
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
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.width * 0.2,
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
                      style: TextStyle(fontFamily: settings.fontFamily,fontSize: settings.fontSize, color: settings.textColor),
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
                        color: Colors.grey[600], size: 45),
                    onPressed: () => log("File uploaded"),
                  ),
                  IconButton(
                    icon: Icon(Icons.camera_alt,
                        color: Colors.grey[600], size: 45),
                    onPressed: () => log("Picture taken"),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: -5,
              right: -5,
              child: IconButton(
                icon: Icon(Icons.send, color: Color.fromRGBO(203, 105, 156, 1), size: 45),
                onPressed: () =>
                    _sendMessage(context), // ✅ Context is passed here!
              ),
            ),
          ],
        ),
      ),
    );
  }
}
