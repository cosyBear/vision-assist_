import 'package:flutter/material.dart';
import '../wigdt/app_setting_provider.dart';
import 'package:provider/provider.dart';

class TextSizeFonts extends StatefulWidget {
  const TextSizeFonts({super.key});

  @override
  State<TextSizeFonts> createState() => _TextSizeFontsState();
}

class _TextSizeFontsState extends State<TextSizeFonts> {
  double fontSize = 16.0; // Declare at the class level

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settings = Provider.of<AppSettingProvider>(context, listen: false);
      setState(() {
        fontSize = settings.fontSize; // Initialize fontSize once
      });
    });
  }

  // Helper function to determine contrasting color
  Color _getContrastingColor(Color backgroundColor) {
    double brightness = (0.299 * backgroundColor.r +
        0.587 * backgroundColor.g +
        0.114 * backgroundColor.b) /
        255;
    return brightness > 0.5 ? Colors.black : Colors.white; // Dark or light text
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingProvider>(context);

    return Container(
      color: settings.backgroundColor,
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Row with Font Selection Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFontButton(settings, "Arial", "Arial", fontSize),
                _buildFontButton(settings, "Verdana", "Verdana", fontSize),
                _buildFontButton(settings, "Calibri", "Calibri", fontSize),
                _buildFontButton(settings, "Times", "Times", fontSize),
              ],
            ),

            const SizedBox(height: 20),

            // Sample Text with Dynamic Font Size
            Text(
              "I love Reading!",
              style: TextStyle(
                fontSize: fontSize,
                color: settings.textColor,
                fontFamily: settings.fontFamily,
              ),
            ),

            const SizedBox(height: 20),

            // Font Size Adjustment Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Subtract Button
                _buildAdjustButton(
                  settings,
                  icon: Icons.remove_circle_outline,
                  onPressed: () {
                    if (fontSize > 10) {
                      setState(() {
                        fontSize -= 1;
                        settings.setFontSize(fontSize);
                      });
                    }
                  },
                ),

                Text(
                  fontSize.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 18),
                ),

                // Add Button
                _buildAdjustButton(
                  settings,
                  icon: Icons.add_circle_outline_sharp,
                  onPressed: () {
                    if (fontSize < 40) {
                      setState(() {
                        fontSize += 1;
                        settings.setFontSize(fontSize);
                      });
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Function to Create Font Selection Buttons
  Widget _buildFontButton(
      AppSettingProvider settings, String label, String fontFamily, double fontSize) {
    final contrastingTextColor = _getContrastingColor(settings.textColor);
    final contrastingBorderColor = contrastingTextColor == Colors.black ? Colors.white : Colors.black;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: TextButton(
        onPressed: () {
          settings.setFontFamily(fontFamily);
        },
        style: TextButton.styleFrom(
          backgroundColor: settings.textColor.withOpacity(0.9), // Ensures it stands out
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: contrastingBorderColor, width: 2.0), // Ensures visibility
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            color: contrastingTextColor, // Dynamically set to contrast with button background
          ),
        ),
      ),
    );
  }

  // Function to Create Add/Subtract Buttons
  Widget _buildAdjustButton(
      AppSettingProvider settings, {
        required IconData icon,
        required VoidCallback onPressed,
      }) {
    final contrastingColor = _getContrastingColor(settings.backgroundColor);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: IconButton(
        icon: Icon(
          icon,
          size: 40,
          color: contrastingColor, // Dynamic icon color
        ),
        onPressed: onPressed,
        splashRadius: 28,
      ),
    );
  }
}
