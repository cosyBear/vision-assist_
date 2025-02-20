import 'package:flutter/material.dart';
import '../../../general/app_setting_provider.dart';
import 'package:provider/provider.dart';
import '../../import_documents/DocumentHandler.dart';
import 'send_button.dart'; // Import the SendButton widget

class UploadBox extends StatefulWidget {
  final TextEditingController controller;

  UploadBox({super.key, required this.controller});

  @override
  _UploadBoxState createState() => _UploadBoxState();
}

class _UploadBoxState extends State<UploadBox> {
  final ScrollController _scrollController = ScrollController();
  final DocumentHandler documentHandler = DocumentHandler(); // Use Singleton Instance

  /// Function to pick a document and extract text
  Future<void> _pickAndExtractDocument() async {
    String? text = await documentHandler.pickAndExtractText();
    if (text != null) {
      setState(() {
        widget.controller.text = text; // Update the text field with extracted text
      });
    }
  }

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
                      controller: widget.controller,
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
                  // **Attach File Icon (Calls _pickAndExtractDocument)**
                  IconButton(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    icon: Icon(Icons.attach_file, color: Colors.grey[600], size: buttonIconsSize),
                    onPressed: _pickAndExtractDocument, // Call function to pick & extract text
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
                controller: widget.controller,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
