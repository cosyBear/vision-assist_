import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../../general/app_setting_provider.dart';
import 'widgt/adjust_button.dart';
import 'widgt/font_button.dart';
import 'widgt/font_size_display.dart';

/*
  This class is the main page for the TextSizeFonts.
  It contains buttons for different fonts, a text display, and buttons to adjust the font size.
  It uses the FontButton, FontSizeDisplay, and AdjustButton classes.
 */

class TextSizeFonts extends StatefulWidget {
  const TextSizeFonts({super.key});

  @override
  State<TextSizeFonts> createState() => _TextSizeFontsState();
}

class _TextSizeFontsState extends State<TextSizeFonts> {
  late double fontSize;

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
        backgroundColor: Color.fromRGBO(18, 18, 18, 1.0),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: GradientText(
          "SteadyEye",
          style: const TextStyle(fontSize: 40),
          colors: const [
            Color.fromRGBO(203, 105, 156, 1.0),
            Color.fromRGBO(22, 173, 201, 1.0),
          ],
        ),
      ),
      body: Container(
        color: settings.backgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: FittedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FontButton(settings: settings, label: "Arial", fontFamily: "Arial", fontSize: fontSize, index: 0),
                    FontButton(settings: settings, label: "Verdana", fontFamily: "Verdana", fontSize: fontSize, index: 1),
                    FontButton(settings: settings, label: "Calibri", fontFamily: "Calibri", fontSize: fontSize, index: 2),
                    FontButton(settings: settings, label: "Times", fontFamily: "Times", fontSize: fontSize, index: 3),
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
                    AdjustButton(icon: Icons.remove_circle_outline, onPressed: () {
                      if (fontSize > 10) {
                        setState(() {
                          fontSize -= 1;
                          settings.setFontSize(fontSize);
                        });
                      }
                    }),
                    FontSizeDisplay(fontSize: fontSize),
                    AdjustButton(icon: Icons.add_circle_outline_sharp, onPressed: () {
                      if (fontSize < 60) {
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
      ),
    );
  }
}
