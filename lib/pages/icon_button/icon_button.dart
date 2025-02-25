import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:steady_eye_2/general/app_setting_provider.dart';

import '../../general/navbar_with_return_button.dart';

class IconButtonSize extends StatelessWidget {
  const IconButtonSize({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingProvider>(context);
    double buttonIconsSize = settings.buttonIconsSize;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final spacing = screenWidth * 0.05;
    double maxButtonSize = 100.0; // Maximum button size

    double fontSize = settings.fontSize;

    if (screenWidth < 1000) {
      fontSize = settings.fontSize > 40 ? 40 : settings.fontSize;
      buttonIconsSize =
          settings.buttonIconsSize > 60 ? 60 : settings.buttonIconsSize;
      maxButtonSize = 60.0;
    }

    return Scaffold(
      backgroundColor: settings.backgroundColor, // Dynamic background color
      appBar: NavbarWithReturnButton(
          fontSize: fontSize, buttonIconsSize: buttonIconsSize),
      body: Column(
        children: [
          // Centering the Icon and Button
          Expanded(
            child: Center(
              // Ensures everything stays centered
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // Centers items horizontally
                crossAxisAlignment: CrossAxisAlignment.center,
                // Centers items vertically
                children: [
                  // First Icon (Centered)
                  Icon(Icons.add_circle,
                      color: Colors.grey, size: buttonIconsSize),

                  SizedBox(width: spacing),

                  // Placeholder Button (Styled like ReadNowButton with Dynamic Radius)
                  TextButton(
                    onPressed: () {}, // Placeholder function
                    style: TextButton.styleFrom(
                      backgroundColor: settings.backgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            buttonIconsSize * 0.5), // Rounded corners
                        side: BorderSide(
                          // This sets the **pink border**
                          color: const Color.fromRGBO(203, 105, 156, 1),
                          // Pink border
                          width: buttonIconsSize /
                                15, // Border thickness scales dynamically
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: buttonIconsSize * 0.4,
                        horizontal: buttonIconsSize * 0.6,
                      ),
                    ),
                    child: Text(
                      "Read Now",
                      style: TextStyle(
                        fontSize: buttonIconsSize * 0.4,
                        // Adjust text size dynamically
                        fontFamily: settings.fontFamily,
                        color: settings.textColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Control Buttons (Fixed at Bottom)
          Padding(
            padding: EdgeInsets.only(bottom: screenHeight * 0.05),
            // Ensures spacing
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Decrease Button Icons Size
                IconButton(
                  icon: Icon(Icons.remove_circle_outline,
                      color: Colors.grey, size: buttonIconsSize),
                  onPressed: () {
                    if (settings.buttonIconsSize > 20) {
                      // Prevent size from going too small
                      settings.setButtonIconsSize(settings.buttonIconsSize - 5);
                    }
                  },
                ),

                SizedBox(width: spacing),

                // **Number Showing Current Size (Added Here)**
                Text(
                  buttonIconsSize.toStringAsFixed(1),
                  // Show button size with one decimal
                  style: TextStyle(
                    fontSize: 18,
                    color: settings.textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(width: spacing),

                // Increase Button Icons Size
                IconButton(
                  icon: Icon(Icons.add_circle_outline_sharp,
                      color: Colors.grey, size: buttonIconsSize),
                  onPressed: () {
                    if (settings.buttonIconsSize < maxButtonSize) {
                      // Prevent excessive size
                      settings.setButtonIconsSize(settings.buttonIconsSize + 5);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
