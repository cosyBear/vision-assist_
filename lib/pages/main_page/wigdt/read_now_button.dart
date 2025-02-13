import 'package:flutter/material.dart';
import '../../../general/app_setting_provider.dart';

class ReadNowButton extends StatelessWidget {
  final void Function(int) goToPage;
  final AppSettingProvider settings;
  final double screenWidth;
  const ReadNowButton({super.key, required this.goToPage, required this.settings, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => goToPage(1),
      style: TextButton.styleFrom(
        backgroundColor: settings.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
          side: BorderSide(
            color: const Color.fromRGBO(203, 105, 156, 1),
            width: 1.0,
          ),
        ),
        minimumSize: Size(screenWidth * 0.20, 50),
        padding: const EdgeInsets.symmetric(vertical: 25),
      ),
      child: Text(
        "Read now",
        style: TextStyle(
          fontSize: screenWidth * 0.020,
          fontFamily: settings.fontFamily,
          color: settings.textColor,
        ),
      ),
    );
  }
}