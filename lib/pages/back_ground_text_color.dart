import 'package:flutter/material.dart';
import 'package:steady_eye_2/wigdt/app_setting_provider.dart';
import 'package:provider/provider.dart';

class BackGroundTextColor extends StatelessWidget {
  const BackGroundTextColor({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingProvider>(context);

    return Container(
      color: settings.backgroundColor, // Dynamic background color
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space sides evenly
        children: [
          // Left 2x2 Grid of Boxes for Text Color
          _build2x2BoxContainer(
            [
              Colors.black,
              Colors.white,
              Colors.yellow,
              Colors.green,
            ],
                (color) => settings.setTextColor(color), // Set text color
          ),
          // Center Column with one large box
          Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            children: [
              _buildTextBox("Text", settings.textColor),
            ],
          ),
          // Right 2x2 Grid of Boxes for Background Color
          _build2x2BoxContainer(
            [
              Colors.black,
              Colors.white,
              Colors.yellow,
              Colors.green,
            ],
                (color) => settings.setBackgroundColor(color), // Set background color
          ),
        ],
      ),
    );
  }

  // Function to create a 2x2 grid for the left and right sides
  Widget _build2x2BoxContainer(
      List<Color> colors, void Function(Color) onTap) {
    return Container(
      width: 250, // Fixed width
      height: 290, // Fixed height to fit two rows of boxes
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(8.0), // Inner padding
      child: GridView.count(
        crossAxisCount: 2, // 2 columns for 2x2 layout
        crossAxisSpacing: 10.0, // Spacing between columns
        mainAxisSpacing: 10.0, // Spacing between rows
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
                  color: Colors.black.withValues(alpha: 51), // Shadow color
                  blurRadius: 4.0,
                  offset: Offset(2, 2), // Shadow offset
                ),
              ],
            ),
          ),
        ))
            .toList(),
      ),
    );
  }

  // Widget for the center "Text" box
  Widget _buildTextBox(String text, Color textColor) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.amberAccent,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: textColor, // Use the dynamic text color
          ),
        ),
      ),
    );
  }
}
