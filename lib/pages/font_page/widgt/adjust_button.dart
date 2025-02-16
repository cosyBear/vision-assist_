import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../general/app_setting_provider.dart';

/*
  This class is a button that adjusts the font size.
  It uses the IconData class.
 */
class AdjustButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const AdjustButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingProvider>(context);
    double buttonSize = settings.buttonIconsSize; // Get the button size from settings

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: buttonSize * 0.2), // Adjust padding dynamically
      child: IconButton(
        icon: Icon(icon, size: buttonSize, color: Colors.grey), // Dynamic icon size
        onPressed: onPressed,
      ),
    );
  }
}
