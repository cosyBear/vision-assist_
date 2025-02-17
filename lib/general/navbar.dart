import 'dart:math';
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../general/app_setting_provider.dart';
import 'package:provider/provider.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  final void Function(int) onIconPressed;
  final int currentIndex; // Track the active page

  const Navbar({super.key, required this.onIconPressed, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final setting = Provider.of<AppSettingProvider>(context);
    double buttonIconsSize = setting.buttonIconsSize;

    // Function to determine icon color based on active page
    Color getIconColor(int index) {
      return currentIndex == index ? Color.fromRGBO(203, 105, 156, 1) : Colors.grey;
    }

    return Container(
      height: max(buttonIconsSize, setting.fontSize) + 24,
      color: const Color.fromRGBO(18, 18, 18, 1.0), // Navbar background
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Stack(
          children: [
            // Left side - Home icon
            Positioned(
              left: 0,
              child: IconButton(
                icon: Icon(Icons.home, color: getIconColor(0), size: buttonIconsSize),
                onPressed: () => onIconPressed(0),
              ),
            ),

            // Right side - Other icons
            Positioned(
              right: 0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.local_library_rounded, color: getIconColor(3), size: buttonIconsSize),
                    onPressed: () => onIconPressed(3),
                  ),
                  IconButton(
                    icon: Icon(Icons.cloud_upload_outlined, color: getIconColor(1), size: buttonIconsSize),
                    onPressed: () => onIconPressed(1),
                  ),
                  IconButton(
                    icon: Icon(Icons.settings, color: getIconColor(2), size: buttonIconsSize),
                    onPressed: () => onIconPressed(2),
                  ),
                ],
              ),
            ),

            // Centered Title (GradientText)
            Center(
              child: GradientText(
                "SteadyEye",
                style: TextStyle(fontSize: setting.fontSize, fontFamily: setting.fontFamily),
                colors: const [
                  Color.fromRGBO(203, 105, 156, 1.0),
                  Color.fromRGBO(22, 173, 201, 1.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
