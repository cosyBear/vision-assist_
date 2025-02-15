import 'package:flutter/material.dart';
import 'package:steady_eye_2/general/app_setting_provider.dart';
import 'wigdt/logo.dart';
import 'wigdt/read_now_button.dart';
import 'wigdt/vision_text.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  final void Function(int) goToPage;

  const MainPage({super.key, required this.goToPage});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingProvider>(context);
    double screenWidth = MediaQuery.of(context).size.width;
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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VisionText(settings: settings, screenWidth: screenWidth),
                  SizedBox(height: screenWidth * 0.02),
                  ReadNowButton(goToPage: goToPage, settings: settings, screenWidth: screenWidth),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}