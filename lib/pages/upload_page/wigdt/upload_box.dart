import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../general/app_setting_provider.dart';
import 'package:provider/provider.dart';
import '../../../general/document_provider.dart';
import '../../display_page/display_page.dart';
import '../../import_documents/DocumentHandler.dart';
import 'camera_recognition.dart';
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
      // Step 1: Pick a file (runs on the UI thread)
      String? filePath = await documentHandler.pickDocument();
      if (filePath == null) {
        return; // User canceled file selection.
      }

      // Step 2: Show the loading dialog.
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Dialogue(message: "Select a file and wait...");
        },
      );

      // Step 3: Offload text extraction to a background isolate.
      // We pass the filePath to our helper function.
      String? extractedText = await compute(extractTextInBackground, filePath);

      // Step 4: Once extraction completes, close the dialog.
      if (!mounted) return;
      Navigator.pop(context); // Close the loading dialog.

      if (extractedText == null || extractedText.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No text extracted from the document.")),
        );
        return;
      }

      // Step 5: Save document details.
      String fileName = documentHandler.lastSelectedFileName ?? "Untitled Document";
      final documentProvider = Provider.of<DocumentProvider>(context, listen: false);
      documentProvider.addDocument(fileName, filePath);

      // Step 6: Update the text field and navigate.
      setState(() {
        widget.controller.text = extractedText;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DisplayPage(
            title: extractedText,
            documentName: fileName.isNotEmpty ? fileName : null,
          ),
        ),
      );
    } catch (e) {
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.pop(context); // Ensure dialog is closed on error.
      }
      if (mounted) {
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
                    onPressed: () =>  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CameraRecognition()),
                    ),
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
// This function runs in a background isolate to extract text.
Future<String?> extractTextInBackground(String filePath) async {
  final DocumentHandler documentHandler = DocumentHandler();
  return await documentHandler.extractText(filePath);
}
