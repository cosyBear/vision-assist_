import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:provider/provider.dart';
import '../../../general/app_setting_provider.dart';
import '../../../general/navbar_with_return_button.dart';
import '../../display_page/display_page.dart';

/* CameraRecognition is a StatefulWidget that handles image picking and text recognition.
   It uses the ImagePicker plugin to pick images from the camera or gallery.
   Then it uses Google ML Kit's Text Recognition API to extract text from the image.
   The extracted text is then passed to the DisplayPage for reading.
 */
class CameraRecognition extends StatefulWidget {
  const CameraRecognition({super.key});

  @override
  _CameraRecognitionState createState() => _CameraRecognitionState();
}

class _CameraRecognitionState extends State<CameraRecognition> {
  final ImagePicker _picker = ImagePicker(); // Instance to pick images
  String extractedText = "";

  // Function to pick an image either from the camera or gallery.
  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source); // Pick image based on the source
    if (image != null) {
      // If an image is picked, extract text from it
      await _extractTextFromImage(File(image.path)); // Pass the image to the extraction function
    }
  }

  // Function to extract text from the image using Google ML Kit's Text Recognition API.
  Future<void> _extractTextFromImage(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile); // Convert image to InputImage format for ML Kit
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin); // Set up the text recognizer for Latin script

    try {
      // Process the image and extract text
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      String extracted = recognizedText.text; // Get the recognized text
      if (extracted.isNotEmpty) {
        // If text is found, update the state and navigate to DisplayPage
        setState(() {
          extractedText = extracted;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DisplayPage(title: extractedText), // Pass the extracted text to DisplayPage
          ),
        );
      } else {
        // If no text is found in the image, show a SnackBar message
        _showSnackBar("No text found in the image.");
      }
    } catch (e) {
      // Handle errors during text recognition
      _showSnackBar("Error extracting text: $e");
    } finally {
      // Always close the text recognizer after usage
      textRecognizer.close();
    }
  }

  // Function to show a SnackBar with a given message.
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingProvider>(context);
    final fontSize = settings.fontSize;
    final buttonIconsSize = settings.buttonIconsSize;
    Color textColor = settings.textColor;

    return Scaffold(
      appBar: NavbarWithReturnButton(fontSize: fontSize, buttonIconsSize: buttonIconsSize),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Vertically center widgets
          children: [
            IconButton(
              icon: Icon(Icons.camera_alt, color: textColor, size: buttonIconsSize),
              onPressed: () => _pickImage(ImageSource.camera), // Call _pickImage with camera as source
            ),
            IconButton(
              icon: Icon(Icons.image, color: textColor, size: buttonIconsSize),
              onPressed: () => _pickImage(ImageSource.gallery), // Call _pickImage with gallery as source
            )
          ],
        ),
      ),
    );
  }
}