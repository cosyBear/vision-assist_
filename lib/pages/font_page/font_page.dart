import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:SteadyEye/general/app_localizations.dart';

import '../../general/app_setting_provider.dart';
import '../../general/navbar_with_return_button.dart';
import 'widgt/adjust_button.dart';
import 'widgt/font_button.dart';
import 'widgt/font_size_display.dart';

class TextSizeFonts extends StatefulWidget {
  const TextSizeFonts({super.key});

  @override
  State<TextSizeFonts> createState() => _TextSizeFontsState();
}

class _TextSizeFontsState extends State<TextSizeFonts> {
  late double fontSize;

  // GlobalKeys for areas we want to instruct.
  final GlobalKey _fontButtonsKey = GlobalKey();
  final GlobalKey _sampleTextKey = GlobalKey();
  final GlobalKey _adjustButtonsKey = GlobalKey();

  TutorialCoachMark? tutorialCoachMark;

  @override
  void initState() {
    super.initState();
    // Initialize fontSize from settings after layout.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settings = Provider.of<AppSettingProvider>(context, listen: false);
      setState(() {
        fontSize = settings.fontSize;
      });
      // Delay a bit before showing the tutorial.
      Future.delayed(const Duration(seconds: 1), () {
        _showTutorialIfNeeded();
      });
    });
  }

  Future<void> _showTutorialIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    // Use a unique key for this page.
    bool hasShown = prefs.getBool('textSizeFontsTutorialShown') ?? false;
    if (!hasShown) {
      _showTutorial();
      await prefs.setBool('textSizeFontsTutorialShown', true);
    }
  }

  void _showTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      alignSkip: Alignment.topRight,
      onFinish: () {
        debugPrint('Tutorial finished');
        return true;
      },
      onSkip: () {
        debugPrint('Tutorial skipped');
        return true;
      },
    );
    tutorialCoachMark?.show(context: context);
  }

  List<TargetFocus> _createTargets() {
    final settings = Provider.of<AppSettingProvider>(context,listen: false);
    return [
      // Target 1: Font Buttons row.
      TargetFocus(
        identify: "FontButtons",
        keyTarget: _fontButtonsKey,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        paddingFocus: 10.0,
        contents: [
          TargetContent(
            // Align the content above the font buttons.
            align: ContentAlign.top,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.black.withValues(alpha: (0.7 * 255)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.tr('chooseFont'),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: settings.fontSize,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    context.tr('chooseFontInstructions'),
                    style: TextStyle(color: Colors.white, fontSize: settings.fontSize),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // Target 2: Sample text ("I love Reading!")
      TargetFocus(
        identify: "SampleText",
        keyTarget: _sampleTextKey,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        paddingFocus: 10.0,
        contents: [
          TargetContent(
            // Align the content below the sample text.
            align: ContentAlign.bottom,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.black.withValues(alpha: (0.7 * 255)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.tr('previewText'),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: settings.fontSize,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    context.tr('previewTextInstructions'),
                    style: TextStyle(color: Colors.white, fontSize: settings.fontSize),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // Target 3: Adjust buttons (plus and minus).
      TargetFocus(
        identify: "AdjustButtons",
        keyTarget: _adjustButtonsKey,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        paddingFocus: 10.0,
        contents: [
          TargetContent(
            // Align the content above the adjust buttons.
            align: ContentAlign.top,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.black.withValues(alpha: (0.7 * 255)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.tr('adjustButtonTitle'),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: settings.fontSize,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    context.tr('adjustButtonInstructions'),
                    style: TextStyle(color: Colors.white, fontSize: settings.fontSize),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingProvider>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double currentFontSize = settings.fontSize;
    double buttonIconsSize = settings.buttonIconsSize;
    double maxFontSize = 60;

    if (screenWidth < 1000) {
      currentFontSize = settings.fontSize > 40 ? 40 : settings.fontSize;
      buttonIconsSize = settings.buttonIconsSize > 60 ? 60 : settings.buttonIconsSize;
      maxFontSize = 40;
    }

    return Scaffold(
      appBar: NavbarWithReturnButton(
          fontSize: currentFontSize, buttonIconsSize: buttonIconsSize),
      body: Container(
        color: settings.backgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: FittedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Font buttons row with a GlobalKey wrapper.
                Container(
                  key: _fontButtonsKey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FontButton(
                        settings: settings,
                        label: "Arial",
                        fontFamily: "Arial",
                        fontSize: currentFontSize,
                        index: 0,
                      ),
                      FontButton(
                        settings: settings,
                        label: "Verdana",
                        fontFamily: "Verdana",
                        fontSize: currentFontSize,
                        index: 0,
                      ),
                      FontButton(
                        settings: settings,
                        label: "Calibri",
                        fontFamily: "Calibri",
                        fontSize: currentFontSize,
                        index: 1,
                      ),
                      FontButton(
                        settings: settings,
                        label: "Times",
                        fontFamily: "Times",
                        fontSize: currentFontSize,
                        index: 1,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Sample text display with a GlobalKey.
                Container(
                  key: _sampleTextKey,
                  child: Text(
                    context.tr('placeholderText'),
                    style: TextStyle(
                      fontSize: currentFontSize,
                      color: settings.textColor,
                      fontFamily: settings.fontFamily,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Adjust buttons row with a GlobalKey.
                Container(
                  key: _adjustButtonsKey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AdjustButton(
                        icon: Icons.remove_circle_outline,
                        onPressed: () {
                          if (currentFontSize > 10) {
                            setState(() {
                              currentFontSize -= 1;
                              settings.setFontSize(currentFontSize);
                            });
                          }
                        },
                      ),
                      FontSizeDisplay(fontSize: currentFontSize),
                      AdjustButton(
                        icon: Icons.add_circle_outline_sharp,
                        onPressed: () {
                          if (currentFontSize < maxFontSize) {
                            setState(() {
                              currentFontSize += 1;
                              settings.setFontSize(currentFontSize);
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
