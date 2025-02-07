import 'package:flutter/material.dart';
import '../wigdt /app_setting_provider.dart';
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
                //buttons
                _buildFontButton(settings, "Arial", "Arial", fontSize),
                _buildFontButton(settings, "Verdana", "Verdana",fontSize),
                _buildFontButton(settings, "Calibri", "Calibri", fontSize),
                _buildFontButton(settings, "Times", "Times", fontSize),

              ],
            ),

            const SizedBox(height: 20),

            // Sample Text with Dynamic Font Size
            Text(
              "Sample i I Text",
              style: TextStyle(
                fontSize: fontSize, // Now updates correctly
                color: settings.textColor,
                fontFamily: settings.fontFamily,
              ),
            ),

            const SizedBox(height: 20),

            // Font Size Adjustment Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline, color: Colors.black , size: 40,),
                  onPressed: () {
                    if (fontSize > 10) {
                      setState(() {
                        fontSize -= 1;
                        settings.setFontSize(fontSize); // Update provider
                      });
                    }
                  },
                ),
                Text(
                  fontSize.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 18),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline_sharp, color: Colors.black,size: 40),
                  onPressed: () {
                    if (fontSize < 40) {
                      setState(() {
                        fontSize += 1;
                        settings.setFontSize(fontSize); // Update provider
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
  Widget _buildFontButton(AppSettingProvider settings, String label, String fontFamily, double fontSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: TextButton(
        onPressed: () {
          settings.setFontFamily(fontFamily);
        },
        style: TextButton.styleFrom(
          backgroundColor: settings.textColor,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: fontSize, color: Colors.black), // Now uses dynamic font size
        ),
      ),
    );
  }

}
