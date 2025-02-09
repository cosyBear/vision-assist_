import 'package:flutter/material.dart';
import '../wigdt/upload_box.dart';
import '../wigdt/upload_text.dart';
import '../wigdt/app_setting_provider.dart';
import 'package:provider/provider.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingProvider>(context);

    return Scaffold(
      backgroundColor: settings.backgroundColor,
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
