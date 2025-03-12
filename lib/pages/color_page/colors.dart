import 'package:flutter/material.dart';
import 'package:SteadyEye/general/app_setting_provider.dart';
import 'package:provider/provider.dart';
import 'package:SteadyEye/pages/color_page/wigdt/color_grid.dart';
import 'package:SteadyEye/pages/color_page/wigdt/text_preview.dart';
import '../../general/navbar_with_return_button.dart';
import 'package:SteadyEye/general/app_localizations.dart';

/*
  This class is the main page for the BackGroundTextColor page.
  It contains two ColorGrids that will allow the user to select the text and background color.
  It also contains a TextPreview that will show the user how the text will look like with the selected colors.
  The user can navigate back to the GlobalSetting page by pressing the back button.
 */
class BackGroundTextColor extends StatelessWidget {
  const BackGroundTextColor({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingProvider>(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double gridWidth = screenWidth < 600 ? 250 : screenWidth * 0.25;
    double gridHeight = screenWidth < 600 ? 290 : screenWidth * 0.30;
    double previewBoxSize = screenWidth < 600 ? 120 : screenWidth * 0.22;
    double crossAxisSpacing = screenWidth < 600 ? 20.0 : screenWidth * 0.05;
    double mainAxisSpacing = screenWidth < 600 ? 50.0 : screenWidth * 0.1;

    double fontSize = settings.fontSize;
    double buttonIconsSize = settings.buttonIconsSize;

    if (screenWidth < 1000) {
      fontSize = settings.fontSize > 40 ? 40 : settings.fontSize;
      buttonIconsSize = settings.buttonIconsSize > 60 ? 60 : settings.buttonIconsSize;
    }

    return Scaffold(
      appBar: NavbarWithReturnButton(fontSize: fontSize, buttonIconsSize: buttonIconsSize),
      body: Container(
        color: settings.backgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ColorGrid(
                      colors: [
                        Colors.black,
                        Colors.white,
                        const Color.fromRGBO(255, 255, 0, 1.0),
                        const Color.fromRGBO(0, 255, 0, 1.0)
                      ],
                      onTap: (color) => settings.setTextColor(color),
                      label: context.tr('textColor'),
                      fontSize: settings.fontSize,
                      textColor: settings.textColor,
                      gridWidth: gridWidth,
                      gridHeight: gridHeight,
                      crossAxisSpacing: crossAxisSpacing,
                      mainAxisSpacing: mainAxisSpacing,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextPreview(
                      text: context.tr('preview'),
                      textColor: settings.textColor,
                      backgroundColor: settings.backgroundColor,
                      fontSize: settings.fontSize,
                      previewBoxSize: previewBoxSize,
                    ),
                  ],
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ColorGrid(
                      colors: [
                        Colors.black,
                        Colors.white,
                        const Color.fromRGBO(255, 255, 0, 1.0),
                        const Color.fromRGBO(0, 255, 0, 1.0)
                      ],
                      onTap: (color) => settings.setBackgroundColor(color),
                      label: context.tr('bgColor'),
                      fontSize: settings.fontSize,
                      textColor: settings.textColor,
                      gridWidth: gridWidth,
                      gridHeight: gridHeight,
                      crossAxisSpacing: crossAxisSpacing,
                      mainAxisSpacing: mainAxisSpacing,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
