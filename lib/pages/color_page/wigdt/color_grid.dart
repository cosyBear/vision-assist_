import 'package:flutter/material.dart';

class ColorGrid extends StatelessWidget {
  final List<Color> colors;
  final void Function(Color) onTap;
  final String label;
  final double fontSize;
  final Color textColor;
  final double gridWidth;
  final double gridHeight;
  final double crossAxisSpacing;
  final double mainAxisSpacing;

  const ColorGrid({
    super.key,
    required this.colors,
    required this.onTap,
    required this.label,
    required this.fontSize,
    required this.textColor,
    required this.gridWidth,
    required this.gridHeight,
    required this.crossAxisSpacing,
    required this.mainAxisSpacing,
  });

  @override
  Widget build(BuildContext context) {
    // Create a local variable for the modified label instead of changing the instance variable
    final String displayLabel = (label == "Background Color" && fontSize > 20) ? "Bg Color" : label;

    return Container(
      width: gridWidth,
      height: gridHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: crossAxisSpacing,
            mainAxisSpacing: mainAxisSpacing,
            physics: const NeverScrollableScrollPhysics(),
            children: colors
                .map((color) => GestureDetector(
              onTap: () => onTap(color),
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  border: Border.all(
                    color: Colors.grey,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(51),
                      blurRadius: 4.0,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
              ),
            ))
                .toList(),
          ),
          Center(
            child: Text(
              displayLabel, // Use the local variable instead of modifying the instance variable
              style: TextStyle(
                fontSize: fontSize,
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
}
