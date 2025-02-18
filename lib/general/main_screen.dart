import 'dart:math';

import 'package:flutter/material.dart';
import 'package:steady_eye_2/pages/library_page/library_page.dart';
import '../pages/upload_page/upload_page.dart';
import 'navbar.dart';
import '../pages/main_page/main_page.dart';
import 'package:provider/provider.dart';
import 'app_setting_provider.dart';
import '../pages/settings_page/setting.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() {
    return _MainScreenState();
  }
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController();

  // This function animates to the given page index.
  void _goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.ease,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingProvider>(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = settings.fontSize;
    double buttonIconsSize = settings.buttonIconsSize;

    if (screenWidth < 1000) {
      fontSize = settings.fontSize > 40 ? 40 : settings.fontSize;
      buttonIconsSize =
          settings.buttonIconsSize > 60 ? 60 : settings.buttonIconsSize;
    }

    return Scaffold(
      appBar: PreferredSize(
        //24 is the padding (horizontal +vertical) of the navbar
        preferredSize: Size.fromHeight(max(buttonIconsSize, fontSize) + 24),
        child: Navbar(onIconPressed: _goToPage), // Custom Navbar
      ),
      backgroundColor: settings.backgroundColor,
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          physics: const PageScrollPhysics(),
          children: [
            MainPage(goToPage: _goToPage),
            UploadPage(),
            GlobalSetting(),
            Library()
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 0),
        // Ensures it's at the very bottom
        child: FloatingActionButton(
          onPressed: () => _goToPage(0),
          backgroundColor: Colors.transparent,
          elevation: 0,
          splashColor: Colors.transparent,
          child:
              const Icon(Icons.keyboard_arrow_up, color: Colors.grey, size: 30),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
