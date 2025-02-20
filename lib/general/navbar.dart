import 'dart:math';
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../general/app_setting_provider.dart';
import 'package:provider/provider.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  final void Function(int) onIconPressed;

  const Navbar({super.key, required this.onIconPressed});

  @override
  Widget build(BuildContext context) {
    final setting = Provider.of<AppSettingProvider>(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = setting.fontSize;
    double buttonIconsSize = setting.buttonIconsSize;

    // Adjust font size and button icon size for smaller screens
    if (screenWidth < 1000) {
      fontSize = setting.fontSize > 40 ? 40 : setting.fontSize;
      buttonIconsSize = setting.buttonIconsSize > 60 ? 60 : setting.buttonIconsSize;

    }

    return Container(
      //24 is the padding (horizontal +vertical) of the navbar
      height: max(buttonIconsSize, fontSize) + 24, // Set custom height
      color: const Color.fromRGBO(18, 18, 18, 1.0), // Navbar background color
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Stack(
          children: [
            // Left side - Home icon, fixed position
            Positioned(
              left: 0,
              child: IconButton(
                icon: Icon(Icons.home, color: Colors.grey, size: buttonIconsSize),
                onPressed: () => onIconPressed(0),
              ),
            ),

            // Right side - Icons, fixed position
            Positioned(
              right: 0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.library_books_outlined,
                        color: Colors.grey, size: buttonIconsSize),
                    onPressed: () => onIconPressed(3),
                  ),
                  IconButton(
                    icon: Icon(Icons.cloud_upload_outlined,
                        color: Colors.grey, size: buttonIconsSize),
                    onPressed: () => onIconPressed(1),
                  ),
                  IconButton(
                    onPressed: () => onIconPressed(2),
                    icon: Icon(Icons.settings,
                        color: Colors.grey, size: buttonIconsSize),
                  ),
                ],
              ),
            ),

            // Centered Title (GradientText) - show only if space allows
              Center(
                child: GradientText(
                  "SteadyEye",
                  style: TextStyle(fontSize: fontSize),
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
