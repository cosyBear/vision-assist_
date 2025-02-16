import 'package:flutter/material.dart';
import '../../../general/app_setting_provider.dart';
import 'package:provider/provider.dart';
import 'send_button.dart'; // Import the SendButton widget

class UploadBox extends StatelessWidget {
  final TextEditingController controller;
  final ScrollController _scrollController = ScrollController();

  UploadBox({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingProvider>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = settings.fontSize;
    double buttonIconsSize = settings.buttonIconsSize;

    if (screenWidth < 1000) {
      fontSize = settings.fontSize > 40 ? 40 : settings.fontSize;
      buttonIconsSize = settings.buttonIconsSize > 60 ? 60 : settings.buttonIconsSize;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.width * 0.25,
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
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    controller: _scrollController,
                    child: TextField(
                      controller: controller,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(
                        fontFamily: settings.fontFamily,
                        fontSize: fontSize,
                        color: settings.textColor,
                      ),
                      decoration: const InputDecoration(
                        hintText: "Enter text...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50), // Space for buttons
              ],
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    icon: Icon(Icons.attach_file, color: Colors.grey[600], size: buttonIconsSize),
                    onPressed: () => print("File uploaded"),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.camera_alt, color: Colors.grey[600], size: buttonIconsSize),
                    onPressed: () => print("Picture taken"),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: SendButton(
                settings: settings,
                buttonSize: buttonIconsSize,
                screenWidth: screenWidth,
                controller: controller,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
