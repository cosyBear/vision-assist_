import 'package:flutter/material.dart';
import '../wigdt /nav_bar.dart';
import 'main_page.dart';
import 'package:provider/provider.dart';
import '../wigdt /app_setting_provider.dart';
import '../pages/setting.dart';

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
    return Scaffold(
      appBar: Navbar(onIconPressed: _goToPage),
      backgroundColor: settings.backgroundColor,
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          physics: const PageScrollPhysics(),
          children: [
            Mainpage(),
            GlobalSetting()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _goToPage(0),
        child: const Icon(Icons.arrow_upward),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
