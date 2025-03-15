import 'dart:io';
import 'package:SteadyEye/general/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_gallery_saver/flutter_image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:provider/provider.dart';
import '../../../general/app_setting_provider.dart';
import '../../../general/navbar_with_return_button.dart';
import '../../display_page/display_page.dart';
import 'dart:typed_data';

class CameraRecognition extends StatefulWidget {
  const CameraRecognition({super.key});

  @override
  CameraRecognitionState createState() => CameraRecognitionState();
}

class CameraRecognitionState extends State<CameraRecognition> {
  final ImagePicker _picker = ImagePicker();
  String extractedText = "";
  bool isDialogVisible = false;

  Future<void> _pickImage(ImageSource source, double fontSize) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      if (source == ImageSource.camera) {
        bool saveToGallery = await _askToSaveImage(fontSize);
        if (saveToGallery) {
          await _saveImageToGallery(File(image.path));
        }
      }

      if (!mounted) return; // Check if the widget is still mounted
      _showLoadingDialog();
      await _extractTextFromImage(File(image.path));
    }
  }

  Future<bool> _askToSaveImage(double fontSize) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(context.tr('saveImageTitle'), style: TextStyle(fontSize: fontSize)),
          content: Text(context.tr('saveImageContent'), style: TextStyle(fontSize: fontSize * 0.8)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.tr('no'), style: TextStyle(fontSize: fontSize * 0.8)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(context.tr('yes'), style: TextStyle(fontSize: fontSize * 0.8)),
            ),
          ],
        );
      },
    ) ?? false;
  }

  Future<void> _saveImageToGallery(File imageFile) async {
    try {
      final Uint8List bytes = await imageFile.readAsBytes();
      await FlutterImageGallerySaver.saveImage(bytes); // No need to assign result here

      if (!mounted) return; // Check if the widget is still mounted
      _showSnackBar(context.tr('imageSaved')); // Show the snackbar when done
    } catch (e) {
      if (!mounted) return; // Check if the widget is still mounted
      _showSnackBar('${context.tr('error')}: $e'); // Show error message
    }
  }


  Future<void> _extractTextFromImage(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    try {
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      String extracted = recognizedText.text;

      if (!mounted) return; // Check if the widget is still mounted
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
        _showSnackBar(context.tr('noTextFound'));
      }
    } catch (e) {
      if (!mounted) return; // Check if the widget is still mounted
      _showSnackBar('${context.tr('errorExtractingText')}: $e');
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
    if (!mounted) return; // Check if the widget is still mounted
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.camera_alt, color: textColor, size: buttonIconsSize),
                    onPressed: () => _pickImage(ImageSource.camera, fontSize),
                    tooltip: context.tr('captureImage'),
                  ),
                  Text(
                    context.tr('takePhoto'),
                    style: TextStyle(fontSize: fontSize, color: textColor),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.image, color: textColor, size: buttonIconsSize),
                    onPressed: () => _pickImage(ImageSource.gallery, fontSize),
                    tooltip: (context.tr('selectImage')),
                  ),
                  Text(
                    context.tr('chooseFromGallery'),
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

