import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:steady_eye_2/general/app_localizations.dart';
import '../general/app_setting_provider.dart';
import 'language_provider.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  final void Function(int) onIconPressed;
  final int currentIndex;

  const Navbar({super.key, required this.onIconPressed, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final setting = Provider.of<AppSettingProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    double buttonIconsSize = setting.buttonIconsSize;

    // Function to determine icon color based on active page
    Color getIconColor(int index) {
      return currentIndex == index ? const Color.fromRGBO(203, 105, 156, 1) : Colors.white;
    }

    return Container(
      height: max(buttonIconsSize, setting.fontSize) + 24,
      color: const Color.fromRGBO(18, 18, 18, 1.0), // Navbar background
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Stack(
          children: [
            // Left side - Home icon
            Positioned(
              left: 0,
              child: IconButton(
                icon: Icon(Icons.home, color: getIconColor(0), size: buttonIconsSize),
                onPressed: () => onIconPressed(0),
              ),
            ),

            // Right side - Other icons
            Positioned(
              right: 0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.cloud_upload_outlined, color: getIconColor(1), size: buttonIconsSize),
                    onPressed: () => onIconPressed(1),
                  ),
                  IconButton(
                    icon: Icon(Icons.settings, color: getIconColor(2), size: buttonIconsSize),
                    onPressed: () => onIconPressed(2),
                  ),
                  IconButton(
                    icon: Icon(Icons.library_books_outlined, color: getIconColor(3), size: buttonIconsSize),
                    onPressed: () => onIconPressed(3),
                  ),

                  // 🌍 Modern Language Selection Dropdown with Flags 🇺🇸 🇧🇪
                  Theme(
                    data: Theme.of(context).copyWith(
                      popupMenuTheme: PopupMenuThemeData(
                        color: Colors.black87, // Dark background for menu
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // Rounded corners
                        ),
                      ),
                    ),
                    child: PopupMenuButton<Locale>(
                      icon: Icon(Icons.language_outlined, color: Colors.white, size: buttonIconsSize),
                      onSelected: (Locale locale) {
                        languageProvider.changeLanguage(locale);
                      },
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                          value: const Locale('en', 'US'),
                          child: Row(
                            children: [
                              Text('🇺🇸', style: TextStyle(fontSize: setting.fontSize + 4)), // American flag
                              const SizedBox(width: 10),
                              Text('English', style: TextStyle(fontSize: setting.fontSize, color: Colors.white)),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: const Locale('nl', 'BE'),
                          child: Row(
                            children: [
                              Text('🇧🇪', style: TextStyle(fontSize: setting.fontSize + 4)), // Belgian flag
                              const SizedBox(width: 10),
                              Text('Nederlands', style: TextStyle(fontSize: setting.fontSize, color: Colors.white)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Centered Title (GradientText) - Uses Localization
            Center(
              child: GradientText(
                context.tr("SteadyEye"), // ✅ Uses translation key
                style: TextStyle(fontSize: setting.fontSize, fontFamily: setting.fontFamily),
                colors: const [
                  Color.fromRGBO(203, 105, 156, 1.0),
                  Color.fromRGBO(22, 173, 201, 1.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
