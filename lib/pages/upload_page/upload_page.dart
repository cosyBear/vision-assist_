import 'package:flutter/material.dart';
import 'wigdt/upload_box.dart';
import 'wigdt/upload_text.dart';
import '../../general/app_setting_provider.dart';
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
    final viewInsets = MediaQuery.of(context).viewInsets; // Get keyboard's viewInsets
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true, // Ensures proper resizing with the keyboard
      backgroundColor: settings.backgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final availableHeight = constraints.maxHeight - viewInsets.bottom;

          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: availableHeight),
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Vertically center
                    crossAxisAlignment: CrossAxisAlignment.center, // Horizontally center
                    children: [
                      UploadBox(controller: _controller),
                      const SizedBox(height: 20),
                      UploadText(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
