import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:steady_eye_2/general/app_setting_provider.dart';
import 'package:provider/provider.dart';
import 'package:steady_eye_2/pages/color_page/wigdt/color_grid.dart';
import 'package:steady_eye_2/pages/color_page/wigdt/text_preview.dart';

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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(18, 18, 18, 1.0),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: GradientText(
          "SteadyEye",
          style: const TextStyle(fontSize: 40),
          colors: const [
            Color.fromRGBO(203, 105, 156, 1.0),
            Color.fromRGBO(22, 173, 201, 1.0),
          ],
        ),
      ),
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
                        const Color.fromRGBO(242, 226, 201, 1),
                        const Color.fromRGBO(122, 252, 206, 1),
                      ],
                      onTap: (color) => settings.setTextColor(color),
                      label: "Text Color",
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
                      text: "Preview",
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
                        const Color.fromRGBO(242, 226, 201, 1),
                        const Color.fromRGBO(122, 252, 206, 1),
                      ],
                      onTap: (color) => settings.setBackgroundColor(color),
                      label: "Background Color",
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
