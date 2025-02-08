import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:steady_eye_2/wigdt/app_setting_provider.dart';
import '../pages/text_size_fonts.dart';
import 'back_ground_text_color.dart';

class GlobalSetting extends StatelessWidget {
  const GlobalSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingProvider>(context, listen: false);

    // Helper function to determine contrasting text color
    Color getContrastingTextColor(Color backgroundColor) {
      double brightness = (0.299 * backgroundColor.r +
          0.587 * backgroundColor.g +
          0.114 * backgroundColor.b) / 255;
      return brightness > 0.5 ? Colors.black : Colors.white;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isSmallScreen = constraints.maxWidth < 600; // Adjust for small screens

        return Center(
          child: isSmallScreen
              ? Column( // Stack elements vertically on small screens
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildContent(context, settings, getContrastingTextColor),
          )
              : Row( // Default row layout for larger screens
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _buildContent(context, settings, getContrastingTextColor),
          ),
        );
      },
    );
  }

// Extract common widget elements into a function
  List<Widget> _buildContent(BuildContext context, AppSettingProvider settings, Color Function(Color) contrastColor) {
    return [
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButton(context, "Text Size & Fonts", TextSizeFonts(), settings, contrastColor),
        ],
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Image.asset(
          'assets/images/logo.png',
          width: MediaQuery.of(context).size.width * 0.3,
          height: MediaQuery.of(context).size.width * 0.3,
        ),
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButton(context, "Background & Text Color", BackGroundTextColor(), settings, contrastColor),
        ],
      ),
    ];
  }

// Extract button creation logic
  Widget _buildButton(BuildContext context, String text, Widget page, AppSettingProvider settings, Color Function(Color) contrastColor) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          settings.backgroundColor.withOpacity(0.8),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(
              color: contrastColor(settings.backgroundColor),
              width: 2.0,
            ),
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20,
          color: contrastColor(settings.backgroundColor),
        ),
      ),
    );
  }

}
