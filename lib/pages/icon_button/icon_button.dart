import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:steady_eye_2/general/app_setting_provider.dart';

class IconButtonSize extends StatelessWidget {
  const IconButtonSize({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingProvider>(context);
    final buttonIconsSize = settings.buttonIconsSize;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final spacing = screenWidth * 0.05;

    return Scaffold(
      backgroundColor: settings.backgroundColor, // Dynamic background color

      body: Column(
        children: [
          // Centering the Icon and Button
          Expanded(
            child: Center( // Ensures everything stays centered
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, // Centers items horizontally
                crossAxisAlignment: CrossAxisAlignment.center, // Centers items vertically
                children: [
                  // First Icon (Centered)
                  Icon(Icons.add_circle, color: Colors.white, size: buttonIconsSize),

                  SizedBox(width: spacing),

                  // Placeholder Button (Styled like ReadNowButton with Dynamic Radius)
                  TextButton(
                    onPressed: () {}, // Placeholder function
                    style: TextButton.styleFrom(
                      backgroundColor: settings.backgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(buttonIconsSize * 0.5), // ✅ Dynamic Radius
                        side: BorderSide(
                          color: const Color.fromRGBO(203, 105, 156, 1),
                          width: 1.0,
                        ),
                      ),
                      minimumSize: Size(screenWidth * 0.20, buttonIconsSize * 1.2), // Scales with icon size
                      padding: const EdgeInsets.symmetric(vertical: 25 , horizontal: 15),
                    ),
                    child: Text(
                      "Read Now",
                      style: TextStyle(
                        fontSize: buttonIconsSize * 0.4, // Adjust text size dynamically
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
            padding: EdgeInsets.only(bottom: screenHeight * 0.05), // Ensures spacing
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Decrease Button Icons Size
                IconButton(
                  icon: Icon(Icons.remove_circle, color: Colors.white, size: buttonIconsSize),
                  onPressed: () {
                    if (settings.buttonIconsSize > 20) { // Prevent size from going too small
                      settings.setButtonIconsSize(settings.buttonIconsSize - 5);
                    }
                  },
                ),

                SizedBox(width: spacing),

                // Increase Button Icons Size
                IconButton(
                  icon: Icon(Icons.add_circle, color: Colors.white, size: buttonIconsSize),
                  onPressed: () {
                    if (settings.buttonIconsSize < 100) { // Prevent excessive size
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
