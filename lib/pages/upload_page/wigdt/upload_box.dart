import 'package:flutter/material.dart';
import '../../../general/app_setting_provider.dart';
import 'package:provider/provider.dart';
import '../../../general/document_provider.dart';
import '../../display_page/display_page.dart';
import '../../import_documents/DocumentHandler.dart';
import 'dialogue.dart';
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

  /// Function to pick a document and extract text using DocumentHandler.
  Future<void> _pickAndExtractDocument() async {
    try {
      // Show "Select a file..." dialog.
      showDialog(
        context: context,
        barrierDismissible: false, // Prevents dismissing the dialog by tapping outside.
        builder: (BuildContext context) {
          return const Dialogue(message: "select a file and wait...");
        },
      );

      // Use the document handler to pick the file and extract its text.
      String? extractedText = await documentHandler.pickAndExtractText();
      if (extractedText == null || extractedText.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No text extracted from the document.")),
          );
        }
        return;
      }

      // Close the "Select a file..." dialog.
      if (context.mounted) Navigator.pop(context);


      // Retrieve the file name from the document handler.
      String fileName = documentHandler.lastSelectedFileName ?? "Untitled Document";

      // Save the document details in DocumentProvider.
      final documentProvider =
      Provider.of<DocumentProvider>(context, listen: false);
      documentProvider.addDocument(fileName, documentHandler.lastSelectedFilePath ?? "");

      // Update the text field and navigate to the DisplayPage.
      setState(() {
        widget.controller.text = extractedText;
      });
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DisplayPage(
              title: extractedText,
              documentName: fileName.isNotEmpty ? fileName : null,
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) Navigator.pop(context);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error extracting text: $e")),
        );
      }
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
                    keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
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
                const SizedBox(height: 50), // Space for buttons.
              ],
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: Row(
                children: [
                  // Attach File Icon.
                  IconButton(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    icon: Icon(Icons.attach_file,
                        color: Colors.grey[600], size: buttonIconsSize),
                    onPressed: _pickAndExtractDocument,
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.camera_alt,
                        color: Colors.grey[600], size: buttonIconsSize),
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
