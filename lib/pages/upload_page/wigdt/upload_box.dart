import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../general/app_setting_provider.dart';
import '../../../general/document_provider.dart';
import '../../display_page/display_page.dart';
import '../../import_documents/DocumentHandler.dart';
import 'dialogue.dart';
import 'send_button.dart';

class UploadBox extends StatefulWidget {
  final TextEditingController controller;
  UploadBox({Key? key, required this.controller}) : super(key: key);

  @override
  _UploadBoxState createState() => _UploadBoxState();
}

class _UploadBoxState extends State<UploadBox> {
  final ScrollController _scrollController = ScrollController();
  final DocumentHandler documentHandler = DocumentHandler();

  // 1. Create two GlobalKeys for clip icon and send button
  final GlobalKey _clipKey = GlobalKey();
  final GlobalKey _sendKey = GlobalKey();

  // Reference to the tutorial
  TutorialCoachMark? tutorialCoachMark;

  @override
  void initState() {
    super.initState();
    // Delay a bit so layout is settled before showing the tutorial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _showTutorialIfNeeded();
      });
    });
  }

  Future<void> _showTutorialIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    // 2. Use a unique key for this tutorial so it shows once
    bool hasShown = prefs.getBool('uploadBoxTutorialShown') ?? false;

    if (!hasShown) {
      _showTutorial();
      await prefs.setBool('uploadBoxTutorialShown', true);
    }
  }

  void _showTutorial() {
    // Debug: check offsets
    if (_clipKey.currentContext == null || _sendKey.currentContext == null) {
      debugPrint("ERROR: One or both keys are not attached to widgets!");
    } else {
      final clipBox = _clipKey.currentContext!.findRenderObject() as RenderBox;
      final clipOffset = clipBox.localToGlobal(Offset.zero);
      debugPrint("Clip Icon offset: $clipOffset, size: ${clipBox.size}");

      final sendBox = _sendKey.currentContext!.findRenderObject() as RenderBox;
      final sendOffset = sendBox.localToGlobal(Offset.zero);
      debugPrint("Send Button offset: $sendOffset, size: ${sendBox.size}");
    }

    // 3. Build the tutorial with two targets
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      alignSkip: Alignment.topRight,
      // Return bool in these callbacks
      onFinish: () {
        debugPrint('Tutorial finished');
        return true; // <-- Return a bool
      },
      onSkip: () {
        debugPrint('Tutorial skipped');
        return true; // <-- Return a bool
      },
    );

    // Show the tutorial
    tutorialCoachMark?.show(context: context);
  }

  List<TargetFocus> _createTargets() {
    return [
      // Target 1: Clip Icon
      TargetFocus(
        identify: 'clipIcon',
        keyTarget: _clipKey,
        shape: ShapeLightFocus.Circle,
        paddingFocus: 8.0,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.arrow_downward, color: Colors.white, size: 30),
                SizedBox(height: 10),
                Text(
                  'Attach/Upload',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Tap here to upload or attach a document.',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),

      // Target 2: Send Button
      TargetFocus(
        identify: 'sendButton',
        keyTarget: _sendKey,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        paddingFocus: 8.0,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.arrow_downward, color: Colors.white, size: 30),
                SizedBox(height: 10),
                Text(
                  'Start',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Tap here to process the text or document!',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    ];
  }

  /// Function to pick a document and extract text using DocumentHandler.
  Future<void> _pickAndExtractDocument() async {
    try {
      // Step 1: Pick a file
      String? filePath = await documentHandler.pickDocument();
      if (filePath == null) return; // User canceled file selection.

      // Step 2: Show the loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Dialogue(message: "Select a file and wait...");
        },
      );

      // Step 3: Offload text extraction to a background isolate
      String? extractedText = await compute(extractTextInBackground, filePath);

      // Step 4: Once extraction completes, close the dialog
      if (!mounted) return;
      Navigator.pop(context); // Close the loading dialog.

      if (extractedText == null || extractedText.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No text extracted from the document.")),
        );
        return;
      }

      // Step 5: Save document details
      String fileName = documentHandler.lastSelectedFileName ?? "Untitled Document";
      final documentProvider = Provider.of<DocumentProvider>(context, listen: false);
      documentProvider.addDocument(fileName, filePath);

      // Step 6: Update the text field and navigate
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
    Color textColor = settings.textColor;

    if (screenWidth < 1000) {
      fontSize = settings.fontSize > 40 ? 40 : settings.fontSize;
      buttonIconsSize = settings.buttonIconsSize > 60 ? 60 : settings.buttonIconsSize;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        width: screenWidth * 0.8,
        height: screenWidth * 0.25,
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
                  IconButton(
                    key: _clipKey,
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    icon: Icon(Icons.attach_file,
                        color: textColor, size: buttonIconsSize),
                    onPressed: _pickAndExtractDocument,
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.camera_alt,
                        color: textColor, size: buttonIconsSize),
                    onPressed: () => debugPrint("Picture taken"),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: SendButton(
                key: _sendKey,
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
