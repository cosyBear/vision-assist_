import 'package:flutter/material.dart';
import '../../../general/app_setting_provider.dart';
import 'package:provider/provider.dart';
import '../../display_page/display_page.dart';
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
    try {
      // Step 1: Show "Select a file..." message
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Select a file...",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
      );

      // Step 2: Wait for user to select a file
      String? filePath = await documentHandler.pickDocument();

      // Close the "Select a file..." dialog
      if (context.mounted) Navigator.pop(context);

      if (filePath == null) {
        // No file selected, show an error message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No file selected.")),
          );
        }
        return;
      }

      // Step 3: Show "Extracting text, please wait..." message
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Extracting text, please wait...",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
      );

      // Step 4: Extract text directly using filePath (No need to pick again)
      String? text;
      if (filePath.endsWith('.pdf')) {
        text = await documentHandler.extractTextFromPdf(filePath);
      } else if (filePath.endsWith('.txt')) {
        text = await documentHandler.extractTextFromTxt(filePath);
      } else if (filePath.endsWith('.docx')) {
        text = await documentHandler.extractTextFromDocx(filePath);
      }


      // Close extraction dialog
      if (context.mounted) Navigator.pop(context);

      // If 'text' is null, provide an empty string to avoid type errors
      String finalText = text ?? '';

      if (text != null && text.isNotEmpty) {
        setState(() {
          widget.controller.text = finalText;
        });

        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DisplayPage(title: finalText),
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No text extracted from the document.")),
          );
        }
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
