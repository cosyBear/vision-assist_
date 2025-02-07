import 'package:flutter/material.dart';
import 'package:steady_eye_2/wigdt%20/app_setting_provider.dart';
import '../wigdt /logo.dart';
import 'package:provider/provider.dart';

class Mainpage extends StatelessWidget {
  const Mainpage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingProvider>(context);// Listens for changes//
    double screenWidth = MediaQuery.of(context).size.width;

    return Center(
        child: Padding(padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Logo(),
        SizedBox(width: MediaQuery.of(context).size.width * 0.1),
        Expanded(
          flex: 3,
            child: Column(
              mainAxisSize: MainAxisSize.min, // Ensure the column takes the minimum space it needs
              crossAxisAlignment: CrossAxisAlignment.center, // Ensure the text in the column is centered
              children: [
                Text(
                  "Vision",
                  style: TextStyle(fontSize: 40, color: settings.textColor),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "See Beyond\nThe Blind Spot",
                  style: TextStyle(fontSize: 20, color: settings.textColor),
                  textAlign: TextAlign.center,
                ),
                TextButton(
                  onPressed: () {
                    settings.setBackgroundColor(Colors.red);
                    },
                  style: TextButton.styleFrom(
                      backgroundColor: Color.fromRGBO(203, 105, 156, 1)
                  ),
                  child: Text(
                    "Read now",
                    style: TextStyle(fontSize: 20, color: settings.textColor),
                  ),
                ),
              ],
            ),
        ),
      ],
    )));
  }
}