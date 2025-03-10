import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:steady_eye_2/general/app_setting_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../general/navbar_with_return_button.dart';

class IconButtonSize extends StatefulWidget {
  const IconButtonSize({Key? key}) : super(key: key);

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
    final settings = Provider.of<AppSettingProvider>(context, listen: false);
    final textColor = settings.textColor;
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
              color: Colors.black.withOpacity(0.7),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Sample Text",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "This shows you how your text will look.",
                    style: TextStyle(color: textColor),
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
              color: Colors.black.withOpacity(0.7),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Make Text Smaller",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Tap here to decrease the text size.",
                    style: TextStyle(color: textColor),
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
              color: Colors.black.withOpacity(0.7),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Make Text Bigger",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Tap here to increase the text size.",
                    style: TextStyle(color: textColor),
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
                  Icon(Icons.add_circle,
                      color: Colors.grey, size: buttonIconsSize),
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
                      "I love reading",
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
                      color: Colors.grey, size: buttonIconsSize),
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
                    fontSize: 18,
                    color: settings.textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: spacing),
                // Plus button (to increase text size)
                IconButton(
                  key: _plusKey,
                  icon: Icon(Icons.add_circle_outline_sharp,
                      color: Colors.grey, size: buttonIconsSize),
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
