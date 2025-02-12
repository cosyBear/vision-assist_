import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:steady_eye_2/general/app_setting_provider.dart';
import '../font_page/text_size_fonts.dart';
import '../color_page/back_ground_text_color.dart';

class GlobalSetting extends StatelessWidget {
  const GlobalSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingProvider>(context, listen: false);
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildButton(
                context, "TEXT SIZE\n &\n FONTS", TextSizeFonts(), settings, Color.fromRGBO(203, 105, 156, 1)),
            Image.asset(
              'assets/images/logo.png',
              width: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.width * 0.2,
            ),
            _buildButton(
                context, "BACKGROUND\n&\n TEXT COLOR", BackGroundTextColor(), settings, Color.fromRGBO(22, 173, 201, 1)),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, Widget page,
      AppSettingProvider settings, Color borderColor) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.25,
      height: MediaQuery.of(context).size.width * 0.2,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: settings.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
            side: BorderSide(
              color: borderColor,
              width: 1.0,
            ),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: screenWidth * 0.020,
            fontFamily: settings.fontFamily,
            color: settings.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
