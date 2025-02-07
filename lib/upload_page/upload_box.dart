import 'package:flutter/material.dart';

class UploadBox extends StatelessWidget {
  final TextEditingController controller;
  final ScrollController _scrollController = ScrollController();

  UploadBox({super.key, required this.controller});

  void _sendMessage(BuildContext context) {
    String text = controller.text.trim();
    if (text.isNotEmpty) {
      print(text);
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => DisplayPage(text: text),
      //   ),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Container(
        width: 700,
        height: 150,
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
                    controller: _scrollController,
                    child: TextField(
                      controller: controller,
                      maxLines: null, // Allows unlimited input
                      keyboardType: TextInputType.multiline, // Multi-line input
                      style: const TextStyle(fontSize: 30, color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: "Enter text...",
                        border: InputBorder.none, // Remove default border
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50), // Space for icons
              ],
            ),
            Positioned(
              left: -15,
              bottom: -5,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.attach_file,
                        color: Colors.grey[600], size: 30),
                    onPressed: () => print("File uploaded"),
                  ),
                  IconButton(
                    icon: Icon(Icons.camera_alt,
                        color: Colors.grey[600], size: 30),
                    onPressed: () => print("Picture taken"),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: -5,
              right: -5,
              child: IconButton(
                icon: Icon(Icons.send, color: Color.fromRGBO(203, 105, 156, 1), size: 30),
                onPressed: () => _sendMessage(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
