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
    double buttonSize = settings.buttonIconsSize.clamp(30, 100); // Ensure reasonable size limits

    return SizedBox(
      width: buttonSize * 3, // Scales width proportionally
      child: TextButton(
        onPressed: () => goToPage(1),
        style: TextButton.styleFrom(
          backgroundColor: settings.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
            side: const BorderSide(
              color: Color.fromRGBO(203, 105, 156, 1),
              width: 1.0,
            ),
          ),
          minimumSize: Size(buttonSize * 2, buttonSize), // Keeps button size responsive
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15), // Normalized padding
        ),
        child: Text(
          "Read now",
          style: TextStyle(
            fontSize: settings.fontSize.clamp(12, 24), // Ensures text remains readable
            fontFamily: settings.fontFamily,
            color: settings.textColor,
          ),
        ),
      ),
    );
  }
}
