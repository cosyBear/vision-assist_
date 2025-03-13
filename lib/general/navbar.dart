import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _uploadKey = GlobalKey();
  final GlobalKey _settingsKey = GlobalKey();
  final GlobalKey _libraryKey = GlobalKey();
  final GlobalKey _languageKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) =>
    _showTutorialIfNeeded());
  }


  /// Checks SharedPreferences to see if the tutorial was already shown.
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
      alignSkip: Alignment.topRight,
      onFinish: () {
        debugPrint("Navbar tutorial finished");
        return true; // Ensure it returns a value
      },
      onSkip: () {
        debugPrint("Navbar tutorial skipped");
        return false; // Ensure it returns a value
      },
    );
    tutorialCoachMark?.show(context: context);
  }


  List<TargetFocus> _createTargets() {
    return [
      TargetFocus(
        identify: "HomeIcon",
        keyTarget: _homeKey,
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

    Color getIconColor(int index) {
      return widget.currentIndex == index ? const Color.fromRGBO(203, 105, 156, 1) : Colors.white;
    }

    return Container(
      height: buttonIconsSize + 24,
      color: const Color.fromRGBO(18, 18, 18, 1.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              child: IconButton(
                key: _homeKey,
                icon: Icon(Icons.home, color: getIconColor(0), size: buttonIconsSize),
                onPressed: () => widget.onIconPressed(0),
              ),
            ),
            Positioned(
              right: 0,
              child: Row(
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
            ),
          ],
        ),
      ),
    );
  }
}
