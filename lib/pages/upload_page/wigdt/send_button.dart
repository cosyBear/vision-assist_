import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../general/app_setting_provider.dart';
import '../../display_page/display_page.dart';

class SendButton extends StatelessWidget {
  final AppSettingProvider settings;
  final double buttonSize;
  final double screenWidth;
  final TextEditingController controller;

  const SendButton({
    super.key,
    required this.settings,
    required this.buttonSize,
    required this.screenWidth,
    required this.controller,
  });

  void _sendMessage(BuildContext context) {
    String text = controller.text.trim();
    if (text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DisplayPage(title: text),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingProvider>(context);

    return TextButton(
      onPressed: () => _sendMessage(context),
      style: TextButton.styleFrom(
        backgroundColor: settings.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonSize * 0.4), // ✅ Dynamic Radius
          side: BorderSide(
            color: const Color.fromRGBO(203, 105, 156, 1),
            width: buttonSize / 15,
          ),
        ),
        minimumSize: Size(screenWidth * 0.20, buttonSize * 1.2),
      ),
      child: Text(
        "Start",
        style: TextStyle(
          fontSize: buttonSize * 0.8, // Adjust text size dynamically
          fontFamily: settings.fontFamily,
          fontWeight: FontWeight.bold,
          color: settings.textColor,
        ),
      ),
    );
  }
}
