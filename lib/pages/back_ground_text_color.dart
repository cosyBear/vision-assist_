import 'package:flutter/material.dart';
import 'package:steady_eye_2/wigdt/app_setting_provider.dart';
import 'package:provider/provider.dart';

class BackGroundTextColor extends StatelessWidget {
  const BackGroundTextColor({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: settings.backgroundColor, // Dynamic background color
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () => Navigator.pop(context), // Navigate back
        ),
      ),
      body: Container(
        color: settings.backgroundColor, // Dynamic background color
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Row for the grids and preview, aligned to the edges
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute the content evenly
              children: [
                // Left 2x2 Grid of Boxes for Text Color
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: _build2x2BoxContainer(
                      colors: [
                        Colors.black,
                        Colors.white,
                        const Color.fromRGBO(242, 226, 201, 1),
                        const Color.fromRGBO(122, 252, 206, 1),
                      ],
                      onTap: (color) => settings.setTextColor(color), // Set text color
                      label: "Text Color", // Label for this grid
                      fontSize: settings.fontSize,
                      textColor: settings.textColor,
                    ),
                  ),
                ),
                // Center Column with one large box
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTextBox(
                      "Preview",
                      settings.textColor,
                      settings.backgroundColor,
                      settings.fontSize,
                    ),
                  ],
                ),
                // Right 2x2 Grid of Boxes for Background Color
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _build2x2BoxContainer(
                      colors: [
                        Colors.black,
                        Colors.white,
                        const Color.fromRGBO(242, 226, 201, 1),
                        const Color.fromRGBO(122, 252, 206, 1),
                      ],
                      onTap: (color) => settings.setBackgroundColor(color), // Set background color
                      label: "Background Color", // Label for this grid
                      fontSize: settings.fontSize,
                      textColor: settings.textColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _build2x2BoxContainer({
    required List<Color> colors,
    required void Function(Color) onTap,
    required String label,
    required double fontSize,
    required Color textColor,
  }) {
    return Container(
      width: 250, // Fixed width
      height: 290, // Fixed height to fit two rows of boxes
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(8.0), // Inner padding
      child: Stack(
        children: [
          GridView.count(
            crossAxisCount: 2, // 2 columns for 2x2 layout
            crossAxisSpacing: 20.0, // Spacing between columns
            mainAxisSpacing: 50.0, // Spacing between rows
            physics: const NeverScrollableScrollPhysics(), // Disable scrolling
            children: colors
                .map((color) => GestureDetector(
              onTap: () => onTap(color), // Call the provided onTap function
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  border: Border.all(
                    color: Colors.grey, // Ensure a contrasting border
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(51), // Shadow color
                      blurRadius: 4.0,
                      offset: const Offset(2, 2), // Shadow offset
                    ),
                  ],
                ),
              ),
            ))
                .toList(),
          ),
          Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: fontSize, // You can adjust the font size here
                fontWeight: FontWeight.bold,
                color: textColor,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget for the center "Preview" box
  Widget _buildTextBox(String text, Color textColor, Color backgroundColor, double fontSize) {
    Color borderColor = backgroundColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.none,
            color: textColor, // Use the dynamic text color
          ),
        ),
      ),
    );
  }
}
