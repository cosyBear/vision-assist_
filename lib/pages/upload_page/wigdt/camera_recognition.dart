import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../display_page/display_page.dart';

class CameraRecognition extends StatefulWidget {
  const CameraRecognition({super.key});

  @override
  _CameraRecognitionState createState() => _CameraRecognitionState();
}

class _CameraRecognitionState extends State<CameraRecognition> {
  final ImagePicker _picker = ImagePicker();
  String extractedText = "";

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      await _extractTextFromImage(File(image.path));
    }
  }

  // Future<void> _extractTextFromImage(File imageFile) async {
  //   final inputImage = InputImage.fromFile(imageFile);
  //   final textRecognizer = GoogleMlKit.vision.textRecognizer();
  //   try {
  //     final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
  //     String extracted = recognizedText.text;
  //     if (extracted.isNotEmpty) {
  //       setState(() {
  //         extractedText = extracted;
  //       });
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => DisplayPage(title: extractedText),
  //         ),
  //       );
  //     } else {
  //       _showSnackBar("No text found in the image.");
  //     }
  //   } catch (e) {
  //     _showSnackBar("Error extracting text: \$e");
  //   } finally {
  //     textRecognizer.close();
  //   }
  // }


  Future<void> _extractTextFromImage(File imageFile) async {
    print("Hello");
    // try {
    //   String extracted = await FlutterOcr.extractText(imageFile.path);
    //   if (extracted.isNotEmpty) {
    //     setState(() {
    //       extractedText = extracted;
    //     });
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => DisplayPage(title: extractedText),
    //       ),
    //     );
    //   } else {
    //     _showSnackBar("No text found in the image.");
    //   }
    // } catch (e) {
    //   _showSnackBar("Error extracting text: $e");
    // }
  }


  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("CameraRecognition build");
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.camera_alt, color: Colors.grey[600]),
          onPressed: () => _pickImage(ImageSource.camera),
        ),
        IconButton(
          icon: Icon(Icons.image, color: Colors.grey[600]),
          onPressed: () => _pickImage(ImageSource.gallery),
        ),
      ],
    );
  }
}
