import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:SteadyEye/general/app_setting_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:SteadyEye/general/app_localizations.dart';

import '../../general/navbar_with_return_button.dart';

class IconButtonSize extends StatefulWidget {
  const IconButtonSize({super.key});

  @override
  State<IconButtonSize> createState() => _IconButtonSizeState();
}

class _IconButtonSizeState extends State<IconButtonSize> {
  // GlobalKeys for our tutorial targets.
  final GlobalKey _sampleTextKey = GlobalKey();
  final GlobalKey _minusKey = GlobalKey();
  final GlobalKey _plusKey = GlobalKey();

  TutorialCoachMark? tutorialCoachMark;

  @override
  void initState() {
    super.initState();
    // Delay until layout is ready, then check if the tutorial should be shown.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 1), () {
        _showTutorialIfNeeded();
      });
    });
  }

  Future<void> _showTutorialIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    // Use a unique key so that the tutorial only appears the first time.
    bool hasShown = prefs.getBool('iconButtonSizeTutorialShown') ?? false;
    if (!hasShown) {
      _showTutorial();
      await prefs.setBool('iconButtonSizeTutorialShown', true);
    }
  }

  void _showTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      alignSkip: Alignment.bottomCenter, // Moves "Skip" to the bottom
      textSkip: "Skip Tutorial", // Customize text
      paddingFocus: 10, // Add some padding around the highlight
      skipWidget: Padding(
        padding: const EdgeInsets.only(bottom: 30), // Add spacing from the bottom
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent, // Highlight color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Rounded corners for the border
              side: const BorderSide(color: Color.fromRGBO(203, 105, 156, 1), width: 4), // Pink border with width
            ),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12), // Bigger button
            textStyle: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold), // Bigger text
          ),
          onPressed: () {
            tutorialCoachMark?.skip();
          },
          child: const Text("Next", style: TextStyle(color: Colors.white)),
        ),
      ),
      onFinish: () {
        debugPrint("Tutorial finished");
        return true;
      },
      onSkip: () {
        debugPrint("Tutorial skipped");
        return false;
      },
    );

    tutorialCoachMark?.show(context: context);
  }

  List<TargetFocus> _createTargets() {
    final settings = Provider.of<AppSettingProvider>(context, listen: false);
    return [
      // Target 1: Sample text button ("I love reading").
      TargetFocus(
        identify: "SampleText",
        keyTarget: _sampleTextKey,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        paddingFocus: 10.0,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.black.withValues(alpha: (0.7 * 255)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.tr('sampleText'),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: settings.fontSize,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    context.tr('sampleTextInstructions'),
                    style: TextStyle(color: Colors.white,fontSize: settings.fontSize),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // Target 2: Minus button.
      TargetFocus(
        identify: "DecreaseSize",
        keyTarget: _minusKey,
        shape: ShapeLightFocus.Circle,
        paddingFocus: 8.0,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.black.withValues(alpha: (0.7 * 255)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.tr('decreaseButton'),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: settings.fontSize,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    context.tr('decreaseButtonInstructions'),
                    style: TextStyle(color: Colors.white,fontSize:settings.fontSize),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // Target 3: Plus button.
      TargetFocus(
        identify: "IncreaseSize",
        keyTarget: _plusKey,
        shape: ShapeLightFocus.Circle,
        paddingFocus: 8.0,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.black.withValues(alpha: (0.7 * 255)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.tr('increaseButton'),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: settings.fontSize,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    context.tr('increaseButtonInstructions'),
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
    double buttonIconsSize = settings.buttonIconsSize;
    Color textColor = settings.textColor;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final spacing = screenWidth * 0.05;
    double maxButtonSize = 100.0; // Maximum button size

    double fontSize = settings.fontSize;
    if (screenWidth < 1000) {
      fontSize = settings.fontSize > 40 ? 40 : settings.fontSize;
      buttonIconsSize = settings.buttonIconsSize > 60 ? 60 : settings.buttonIconsSize;
      maxButtonSize = 60.0;
    }

    return Scaffold(
      backgroundColor: settings.backgroundColor,
      appBar: NavbarWithReturnButton(
          fontSize: fontSize, buttonIconsSize: buttonIconsSize),
      body: Column(
        children: [
          // Centering the Icon and Sample Text Button.
          Expanded(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.favorite,
                      color: textColor, size: buttonIconsSize),
                  SizedBox(width: spacing),
                  // Sample text button, showing "I love reading".
                  TextButton(
                    key: _sampleTextKey,
                    onPressed: () {}, // For demonstration only.
                    style: TextButton.styleFrom(
                      backgroundColor: settings.backgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(buttonIconsSize * 0.5),
                        side: BorderSide(
                          color: const Color.fromRGBO(203, 105, 156, 1),
                          width: buttonIconsSize / 15,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: buttonIconsSize * 0.4,
                        horizontal: buttonIconsSize * 0.6,
                      ),
                    ),
                    child: Text(
                      context.tr('placeholderText'),
                      style: TextStyle(
                        fontSize: buttonIconsSize * 0.4,
                        fontFamily: settings.fontFamily,
                        color: settings.textColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom Control Buttons (plus and minus).
          Padding(
            padding: EdgeInsets.only(bottom: screenHeight * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Minus button (to decrease text size)
                IconButton(
                  key: _minusKey,
                  icon: Icon(Icons.remove_circle_outline,
                      color: textColor, size: buttonIconsSize),
                  onPressed: () {
                    if (settings.buttonIconsSize > 20) {
                      settings.setButtonIconsSize(settings.buttonIconsSize - 5);
                    }
                  },
                ),
                SizedBox(width: spacing),
                // Display current button size.
                Text(
                  buttonIconsSize.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: fontSize,
                    color: settings.textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: spacing),
                // Plus button (to increase text size)
                IconButton(
                  key: _plusKey,
                  icon: Icon(Icons.add_circle_outline_sharp,
                      color: textColor, size: buttonIconsSize),
                  onPressed: () {
                    if (settings.buttonIconsSize < maxButtonSize) {
                      settings.setButtonIconsSize(settings.buttonIconsSize + 5);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
