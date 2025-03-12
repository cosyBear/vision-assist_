import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:SteadyEye/general/app_localizations.dart';

import 'wigdt/logo.dart';
import 'wigdt/read_now_button.dart';
import 'wigdt/vision_text.dart';
import '../../general/app_setting_provider.dart';

class MainPage extends StatefulWidget {
  final void Function(int) goToPage;

  const MainPage({super.key, required this.goToPage});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Create a GlobalKey for the "Read Now" button.
  final GlobalKey _readNowButtonKey = GlobalKey();

  // Reference to the TutorialCoachMark instance.
  TutorialCoachMark? tutorialCoachMark;

  @override
  void initState() {
    super.initState();
    // Delay a bit so the layout is fully computed before showing the tutorial.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 1), () {
        _showTutorialIfNeeded();
      });
    });
  }

  Future<void> _showTutorialIfNeeded() async {
    // Rename the key or remove this check while testing
    final prefs = await SharedPreferences.getInstance();
    bool hasShown = prefs.getBool('mainPageTutorialShown_v2') ?? false;

    if (!hasShown) {
      _showTutorial();
      await prefs.setBool('mainPageTutorialShown_v2', true);
    }
  }

  void _showTutorial() {
    // Debug: Print the offset and size of the button.
    if (_readNowButtonKey.currentContext != null) {
      final box = _readNowButtonKey.currentContext!.findRenderObject() as RenderBox;
      final offset = box.localToGlobal(Offset.zero);
      final size = box.size;
      debugPrint("ReadNowButton offset: dx=${offset.dx}, dy=${offset.dy}, width=${size.width}, height=${size.height}");
    } else {
      debugPrint("ERROR: ReadNowButton key is not attached!");
    }

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

    // Show the tutorial by passing in the BuildContext.
    tutorialCoachMark?.show(context: context);
  }

  List<TargetFocus> _createTargets() {
    final settings = Provider.of<AppSettingProvider>(context,listen: false);
    return [
      TargetFocus(
        identify: 'ReadNowButton',
        keyTarget: _readNowButtonKey,
        shape: ShapeLightFocus.RRect, // or ShapeLightFocus.Circle
        radius: 8,                    // Round corners of the highlight
        paddingFocus: 10.0,           // Padding around the highlight
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Example arrow icon
                Icon(
                  Icons.arrow_downward,
                  color: Colors.white,
                  size: settings.buttonIconsSize,
                ),
                SizedBox(height: 10),
                Text(
                  context.tr('readNowButton'),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: settings.fontSize,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  context.tr('readNowButtonInstructions'),
                  style: TextStyle(color: Colors.white, fontSize: settings.fontSize),
                ),
              ],
            ),
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Logo(),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Vertically centered.
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: VisionText(
                      settings: settings,
                      screenWidth: screenWidth,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  // Attach the GlobalKey to the "Read Now" button.
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ReadNowButton(
                      key: _readNowButtonKey,
                      goToPage: widget.goToPage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
