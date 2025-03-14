import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../general/app_setting_provider.dart';
import 'language_provider.dart';
import 'package:SteadyEye/general/app_localizations.dart';

class NavbarWithTutorial extends StatefulWidget implements PreferredSizeWidget {
  final void Function(int) onIconPressed;
  final int currentIndex;

  const NavbarWithTutorial({super.key, required this.onIconPressed, required this.currentIndex});

  @override
  State<NavbarWithTutorial> createState() => _NavbarWithTutorialState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _NavbarWithTutorialState extends State<NavbarWithTutorial> {
  TutorialCoachMark? tutorialCoachMark;

  final GlobalKey _steadyEyeKey = GlobalKey(); // Key for tutorial
  final GlobalKey _uploadKey = GlobalKey();
  final GlobalKey _settingsKey = GlobalKey();
  final GlobalKey _libraryKey = GlobalKey();
  final GlobalKey _languageKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showTutorialIfNeeded());
  }

  Future<void> _showTutorialIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    bool hasShown = prefs.getBool('navbarTutorialShown') ?? false;
    if (!hasShown) {
      _showTutorial();
      await prefs.setBool('navbarTutorialShown', true);
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
        debugPrint("Navbar tutorial finished");
        return true;
      },
      onSkip: () {
        debugPrint("Navbar tutorial skipped");
        return false;
      },
    );

    tutorialCoachMark?.show(context: context);
  }



  List<TargetFocus> _createTargets() {
    return [
      TargetFocus(
        identify: "SteadyEyeText",
        keyTarget: _steadyEyeKey,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: _buildTooltip(context.tr('homeTitle'), context.tr('homeInstructions')),
          ),
        ],
      ),
      TargetFocus(
        identify: "UploadIcon",
        keyTarget: _uploadKey,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: _buildTooltip(context.tr('uploadTitle'), context.tr('uploadInstructions')),
          ),
        ],
      ),
      TargetFocus(
        identify: "SettingsIcon",
        keyTarget: _settingsKey,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: _buildTooltip(context.tr('settingsTitle'), context.tr('settingsInstructions')),
          ),
        ],
      ),
      TargetFocus(
        identify: "LibraryIcon",
        keyTarget: _libraryKey,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: _buildTooltip(context.tr('libraryNavbarTitle'), context.tr('libraryNavbarInstructions')),
          ),
        ],
      ),
      TargetFocus(
        identify: "LanguageIcon",
        keyTarget: _languageKey,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: _buildTooltip(context.tr('languageTitle'), context.tr('languageInstructions')),
          ),
        ],
      ),
    ];
  }

  Widget _buildTooltip(String title, String description) {
    final setting = Provider.of<AppSettingProvider>(context, listen: false);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: setting.fontSize, color: Colors.white)),
        const SizedBox(height: 8),
        Text(description, style: TextStyle(fontSize: setting.fontSize, color: Colors.white)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final setting = Provider.of<AppSettingProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    double buttonIconsSize = setting.buttonIconsSize;
    double screenWidth = MediaQuery.of(context).size.width;

    Color getIconColor(int index) {
      return widget.currentIndex == index ? const Color.fromRGBO(203, 105, 156, 1) : Colors.white;
    }

    return Container(
      height: buttonIconsSize + 24,
      color: const Color.fromRGBO(18, 18, 18, 1.0),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05), // Dynamic padding
        child: Row(
          children: [
            // "SteadyEye" logo (Home button) at the left
            GestureDetector(
              key: _steadyEyeKey,
              onTap: () => widget.onIconPressed(0),
              child: GradientText(
                context.tr("SteadyEye"),
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: setting.fontSize, fontFamily: setting.fontFamily),
                colors: const [
                  Color.fromRGBO(203, 105, 156, 1.0),
                  Color.fromRGBO(22, 173, 201, 1.0),
                ],
              ),
            ),

            // Spacer to push icons to the right
            Spacer(),

            // Icons on the right side
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  key: _uploadKey,
                  icon: Icon(Icons.cloud_upload_outlined, color: getIconColor(1), size: buttonIconsSize),
                  onPressed: () => widget.onIconPressed(1),
                ),
                IconButton(
                  key: _settingsKey,
                  icon: Icon(Icons.settings, color: getIconColor(2), size: buttonIconsSize),
                  onPressed: () => widget.onIconPressed(2),
                ),
                IconButton(
                  key: _libraryKey,
                  icon: Icon(Icons.library_books_outlined, color: getIconColor(3), size: buttonIconsSize),
                  onPressed: () => widget.onIconPressed(3),
                ),
                PopupMenuButton<Locale>(
                  key: _languageKey,
                  icon: Icon(Icons.language_outlined, color: Colors.white, size: buttonIconsSize),
                  onSelected: (Locale locale) {
                    languageProvider.changeLanguage(locale);
                  },
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      value: const Locale('en', 'US'),
                      child: Text('🇺🇸 en', style: TextStyle(fontSize: setting.fontSize)),
                    ),
                    PopupMenuItem(
                      value: const Locale('nl', 'BE'),
                      child: Text('🇧🇪 nl', style: TextStyle(fontSize: setting.fontSize)),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
