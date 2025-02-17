import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../general/app_setting_provider.dart';

class ReadNowButton extends StatelessWidget {
  final void Function(int) goToPage;

  const ReadNowButton({
    super.key,
    required this.goToPage,
  });

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingProvider>(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double buttonIconsSize = settings.buttonIconsSize;

    if (screenWidth < 1000) {
      buttonIconsSize =
          settings.buttonIconsSize > 60 ? 60 : settings.buttonIconsSize;
    }

    return TextButton(
      onPressed: () => goToPage(1),
      style: TextButton.styleFrom(
        backgroundColor: settings.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonIconsSize * 0.4),
          // ✅ Dynamic Radius
          side: BorderSide(
            color: const Color.fromRGBO(203, 105, 156, 1),
            width: buttonIconsSize / 20,
          ),
        ),
        minimumSize: Size(screenWidth * 0.25, buttonIconsSize * 1.2),
      ),
      child: Text(
        "Read Now",
        style: TextStyle(
          fontSize: buttonIconsSize * 0.4, // Adjust text size dynamically
          fontFamily: settings.fontFamily,
          fontWeight: FontWeight.bold,
          color: settings.textColor,
        ),
      ),
    );
  }
}
