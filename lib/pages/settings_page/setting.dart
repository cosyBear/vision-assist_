import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:SteadyEye/general/app_setting_provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:SteadyEye/general/app_localizations.dart';

import '../font_page/font_page.dart';
import '../color_page/colors.dart';
import '../icon_button/icon_button.dart';
import 'widgt/settings_button.dart';

class GlobalSetting extends StatefulWidget {
  const GlobalSetting({super.key});

  @override
  State<GlobalSetting> createState() => _GlobalSettingState();
}

class _GlobalSettingState extends State<GlobalSetting> {
  // GlobalKeys for each SettingsButton.
  final GlobalKey _textButtonKey = GlobalKey();
  final GlobalKey _iconButtonKey = GlobalKey();
  final GlobalKey _colorButtonKey = GlobalKey();

  TutorialCoachMark? tutorialCoachMark;

  @override
  void initState() {
    super.initState();
    // Wait until layout is complete, then check if tutorial needs to be shown.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 1), () {
        _showTutorialIfNeeded();
      });
    });
  }

  Future<void> _showTutorialIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    // Use a unique key to track if the tutorial has been shown.
    bool hasShown = prefs.getBool('globalSettingTutorialShown') ?? false;
    if (!hasShown) {
      _showTutorial();
      await prefs.setBool('globalSettingTutorialShown', true);
    }
  }

  void _showTutorial() {
    final settings = Provider.of<AppSettingProvider>(context, listen: false);

    double screenWidth = MediaQuery.of(context).size.width;
    double buttonIconsSize = settings.buttonIconsSize;

    if (screenWidth < 1000) {
      buttonIconsSize =
      settings.buttonIconsSize > 60 ? 60 : settings.buttonIconsSize;
    }
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      alignSkip: Alignment.bottomCenter, // Moves "Skip" to the bottom
      textSkip: "Skip Tutorial", // Customize text
      paddingFocus: 10, // Add some padding around the highlight
      skipWidget: Padding(
        padding: const EdgeInsets.only(bottom: 30), // Add spacing from the bottom
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(buttonIconsSize * 0.4),
              side: BorderSide(color: Color.fromRGBO(203, 105, 156, 1), width: buttonIconsSize / 15),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16), // Increased padding
            textStyle: TextStyle(fontSize: buttonIconsSize * 0.8, fontWeight: FontWeight.bold),
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
    // Get the text color from your settings.
    final settings = Provider.of<AppSettingProvider>(context, listen: false);
    return [
      // Target for the TEXT button: Show overlay content to the RIGHT.
      TargetFocus(
        identify: "TextButton",
        keyTarget: _textButtonKey,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        paddingFocus: 10.0,
        contents: [
          TargetContent(
            // Align content to the right of the target.
            align: ContentAlign.right,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.black.withValues(alpha: (0.7 * 255)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Arrow removed.
                  const SizedBox(height: 10),
                  Text(
                    context.tr('settingsTextTitle'),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: settings.fontSize,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    context.tr('settingsTextInstructions'),
                    style: TextStyle(color: Colors.white, fontSize: settings.fontSize),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // Target for the BUTTON (IconButtonSize) button: Show overlay content at the TOP.
      TargetFocus(
        identify: "IconButtonSize",
        keyTarget: _iconButtonKey,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        paddingFocus: 10.0,
        contents: [
          TargetContent(
            // Align content to the top of the target.
            align: ContentAlign.top,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.black.withValues(alpha: (0.7 * 255)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Arrow removed.
                  const SizedBox(height: 10),
                  Text(
                    context.tr('settingsButtonTitle'),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: settings.fontSize,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    context.tr('settingsButtonInstructions'),
                    style: TextStyle(color: Colors.white, fontSize: settings.fontSize),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // Target for the COLOR button: Show overlay content to the LEFT.
      TargetFocus(
        identify: "ColorButton",
        keyTarget: _colorButtonKey,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        paddingFocus: 10.0,
        contents: [
          TargetContent(
            // Align content to the left of the target.
            align: ContentAlign.left,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              color:  Colors.black.withValues(alpha: (0.7 * 255)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Arrow removed.
                  const SizedBox(height: 10),
                  Text(
                    context.tr('settingsColorTitle'),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: settings.fontSize,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    context.tr('settingsColorInstructions'),
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
    final settings = Provider.of<AppSettingProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: settings.backgroundColor,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Attach GlobalKey to the TEXT SettingsButton.
            SettingsButton(
              key: _textButtonKey,
              text: context.tr('text'),
              page: TextSizeFonts(),
              settings: settings,
              borderColor: const Color.fromRGBO(203, 105, 156, 1),
            ),
            SettingsButton(
              key: _iconButtonKey,
              text: context.tr('button'),
              page: IconButtonSize(),
              settings: settings,
              borderColor: const Color.fromRGBO(203, 105, 156, 1),
            ),
            // Attach GlobalKey to the COLOR SettingsButton.
            SettingsButton(
              key: _colorButtonKey,
              text: context.tr('color'),
              page: BackGroundTextColor(),
              settings: settings,
              borderColor: const Color.fromRGBO(203, 105, 156, 1),
            ),
          ],
        ),
      ),
    );
  }
}
