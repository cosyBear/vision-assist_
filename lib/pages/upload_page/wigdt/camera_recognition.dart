import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:provider/provider.dart';
import '../../../general/app_setting_provider.dart';
import '../../../general/navbar_with_return_button.dart';
import '../../display_page/display_page.dart';

class CameraRecognition extends StatefulWidget {
  const CameraRecognition({super.key});

  @override
  _CameraRecognitionState createState() => _CameraRecognitionState();
}

class _CameraRecognitionState extends State<CameraRecognition> {
  final ImagePicker _picker = ImagePicker();
  String extractedText = "";
  bool isDialogVisible = false;

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      _showLoadingDialog();
      await _extractTextFromImage(File(image.path));
    }
  }

  Future<void> _extractTextFromImage(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    try {
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      String extracted = recognizedText.text;

      _dismissLoadingDialog();

      if (extracted.isNotEmpty) {
        setState(() {
          extractedText = extracted;
        });

        // Navigate to DisplayPage and wait for the user to return
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DisplayPage(title: extractedText),
          ),
        );

        // After DisplayPage is closed, navigate back to Upload Page
        if (mounted) Navigator.pop(context);
      } else {
        _showSnackBar("No text found in the image.");
      }
    } catch (e) {
      _showSnackBar("Error extracting text: $e");
    } finally {
      textRecognizer.close();
    }
  }

  void _showLoadingDialog() {
    if (!isDialogVisible) {
      isDialogVisible = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        },
      );
    }
  }

  void _dismissLoadingDialog() {
    if (isDialogVisible) {
      isDialogVisible = false;
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _dismissLoadingDialog();
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingProvider>(context);
    final fontSize = settings.fontSize;
    final buttonIconsSize = settings.buttonIconsSize;
    Color textColor = settings.textColor;
    Color backgroundColor = settings.backgroundColor;

    return Scaffold(
      appBar: NavbarWithReturnButton(fontSize: fontSize, buttonIconsSize: buttonIconsSize),
      backgroundColor: backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Add padding for spacing
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Vertically center widgets
            crossAxisAlignment: CrossAxisAlignment.center, // Align widgets horizontally
            children: [
              // Camera Icon with text description
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.camera_alt, color: textColor, size: buttonIconsSize),
                    onPressed: () => _pickImage(ImageSource.camera), // Call _pickImage with camera as source
                    tooltip: "Capture image with camera", // Accessibility description
                  ),
                  Text(
                    "Take a Photo",
                    style: TextStyle(fontSize: fontSize, color: textColor),
                  ),
                ],
              ),
              const SizedBox(height: 20), // Add space between buttons
              // Gallery Icon with text description
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.image, color: textColor, size: buttonIconsSize),
                    onPressed: () => _pickImage(ImageSource.gallery), // Call _pickImage with gallery as source
                    tooltip: "Select image from gallery", // Accessibility description
                  ),
                  Text(
                    "Choose from Gallery",
                    style: TextStyle(fontSize: fontSize, color: textColor),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

