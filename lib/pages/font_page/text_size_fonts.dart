import 'package:flutter/material.dart';
import '../../general/app_setting_provider.dart';
import 'package:provider/provider.dart';

class TextSizeFonts extends StatefulWidget {
  const TextSizeFonts({super.key});

  @override
  State<TextSizeFonts> createState() => _TextSizeFontsState();
}

class _TextSizeFontsState extends State<TextSizeFonts> {
  double fontSize = 16.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settings = Provider.of<AppSettingProvider>(context, listen: false);
      setState(() {
        fontSize = settings.fontSize;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: settings.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: settings.backgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildFontButton(settings, "Arial", "Arial", fontSize, 0),
                  _buildFontButton(settings, "Verdana", "Verdana", fontSize, 1),
                  _buildFontButton(settings, "Calibri", "Calibri", fontSize, 2),
                  _buildFontButton(settings, "Times", "Times", fontSize, 3),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "I love Reading!",
                style: TextStyle(
                  fontSize: fontSize,
                  color: settings.textColor,
                  fontFamily: settings.fontFamily,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildAdjustButton(settings,
                      icon: Icons.remove_circle_outline, onPressed: () {
                    if (fontSize > 10) {
                      setState(() {
                        fontSize -= 1;
                        settings.setFontSize(fontSize);
                      });
                    }
                  }),
                  Text(fontSize.toStringAsFixed(1),
                      style: const TextStyle(fontSize: 18, color: Colors.grey)),
                  _buildAdjustButton(settings,
                      icon: Icons.add_circle_outline_sharp, onPressed: () {
                    if (fontSize < 40) {
                      setState(() {
                        fontSize += 1;
                        settings.setFontSize(fontSize);
                      });
                    }
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFontButton(AppSettingProvider settings, String label,
      String fontFamily, double fontSize, int index) {
    Color borderColor = settings.backgroundColor.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;

    // Alternating colors based on index
    Color buttonColor = (index % 2 == 0)
        ? const Color.fromRGBO(203, 105, 156, 1) // Pink
        : const Color.fromRGBO(22, 173, 201, 1); // Blue

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: buttonColor,
          side: BorderSide(color: borderColor, width: 1.5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
        onPressed: () {
          settings.setFontFamily(fontFamily);
        },
        child: Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            color: settings.textColor,
            fontFamily: fontFamily,
          ),
        ),
      ),
    );
  }

  Widget _buildAdjustButton(AppSettingProvider settings,
      {required IconData icon, required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: IconButton(
        icon: Icon(icon, size: 45, color: Colors.grey),
        onPressed: onPressed,
      ),
    );
  }
}
