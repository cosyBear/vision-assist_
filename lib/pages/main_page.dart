import 'package:flutter/material.dart';
import 'package:steady_eye_2/wigdt/app_setting_provider.dart';
import '../wigdt/logo.dart';
import 'package:provider/provider.dart';

class Mainpage extends StatelessWidget {
  final void Function(int) goToPage; // Accepts _goToPage function
  const Mainpage({super.key, required this.goToPage}); // Constructor update

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingProvider>(context);
    double screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          // Align Row's contents to the left
          children: [
            // LOGO takes **60% of the width**
            Expanded(
              flex: 6, // **60% of space**
              child: Align(
                alignment: Alignment.centerLeft,
                // Align logo to the left of the space
                child: Logo(),
              ),
            ),
            // TEXT takes **40% of the width**
            Expanded(
              flex: 4,
              // **40% of space**
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                // Align text to the start of its space
                children: [
                  // First text: Vision
                  Text(
                    "Vision",
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      color: settings.textColor,
                      fontFamily: settings.fontFamily,
                    ),
                    textAlign: TextAlign.start, // Align text to the left
                  ),
                  // Second text: See Beyond
                  Text(
                    "See Beyond\nThe Blind Spot",
                    style: TextStyle(
                      fontSize: screenWidth * 0.020,
                      color: settings.textColor,
                      fontFamily: settings.fontFamily,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.start, // Align text to the left
                  ),
                  // Add space between text and button
                  SizedBox(height: screenWidth * 0.02),
                  // Add space between the text and button
                  // TextButton
                  TextButton(
                    onPressed: () {
                      goToPage(1); // Navigate to UploadPage (index 1)
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: settings.backgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        side: BorderSide(
                          color: const Color.fromRGBO(203, 105, 156, 1),
                          width: 1.0,
                        ),
                      ),
                      minimumSize: Size(screenWidth * 0.20, 50),
                      padding: EdgeInsets.symmetric(vertical: 25),
                    ),
                    child: Text(
                      "Read now",
                      style: TextStyle(
                        fontSize: screenWidth * 0.020,
                        fontFamily: settings.fontFamily,
                        color: settings.textColor,
                      ),
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
