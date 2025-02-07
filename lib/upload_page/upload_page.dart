import 'package:flutter/material.dart';
import 'upload_box.dart';
import 'upload_text.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UploadBox(controller: _controller), // Text input + icons
            const UploadText(), // Instruction text
          ],
        ),
      ),
    );
  }
}
