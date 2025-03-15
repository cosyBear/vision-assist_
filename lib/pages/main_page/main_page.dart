import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

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
