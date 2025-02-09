import 'package:flutter/material.dart';
import 'package:steady_eye_2/wigdt/app_setting_provider.dart';
import 'package:provider/provider.dart';

class BackGroundTextColor extends StatelessWidget {
  const BackGroundTextColor({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingProvider>(context);

    // Get screen width
    double screenWidth = MediaQuery.of(context).size.width;

    // Determine the grid size based on the screen width
    double gridWidth = screenWidth < 600 ? 250 : screenWidth * 0.3;  // 250 for small screens, 30% of screen width for larger screens
    double gridHeight = screenWidth < 600 ? 290 : screenWidth * 0.35; // Adjust height based on screen size

    // Determine preview box size based on screen width
    double previewBoxSize = screenWidth < 600 ? 120 : screenWidth * 0.22;  // 120 for small screens, 20% of screen width for larger screens

    // Determine the spacing values based on screen width
    double crossAxisSpacing = screenWidth < 600 ? 20.0 : screenWidth * 0.05; // 20 for small screens, 5% of screen width for larger screens
    double mainAxisSpacing = screenWidth < 600 ? 50.0 : screenWidth * 0.1;   // 50 for small screens, 10% of screen width for larger screens

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
                      gridWidth: gridWidth,
                      gridHeight: gridHeight,
                      crossAxisSpacing: crossAxisSpacing,
                      mainAxisSpacing: mainAxisSpacing,
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
                      previewBoxSize, // Pass dynamic size for preview box
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
                      gridWidth: gridWidth,
                      gridHeight: gridHeight,
                      crossAxisSpacing: crossAxisSpacing,
                      mainAxisSpacing: mainAxisSpacing,
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
    required double gridWidth,
    required double gridHeight,
    required double crossAxisSpacing,
    required double mainAxisSpacing,
  }) {
    // Conditionally change the label text if its length is greater than 20
    if(label=="Background Color" && fontSize>20){
      label="Bg Color";
    }

    return Container(
      width: gridWidth, // Responsive width
      height: gridHeight, // Responsive height
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(8.0), // Inner padding
      child: Stack(
        children: [
          GridView.count(
            crossAxisCount: 2, // 2 columns for 2x2 layout
            crossAxisSpacing: crossAxisSpacing, // Responsive column spacing
            mainAxisSpacing: mainAxisSpacing,   // Responsive row spacing
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
              label, // Use the modified label here
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
  Widget _buildTextBox(String text, Color textColor, Color backgroundColor, double fontSize, double previewBoxSize) {
    Color borderColor = backgroundColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
    return Container(
      width: previewBoxSize,  // Dynamic width for preview box
      height: previewBoxSize, // Dynamic height for preview box
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
