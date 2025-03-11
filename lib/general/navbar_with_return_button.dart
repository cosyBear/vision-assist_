import 'dart:math';
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:provider/provider.dart';
import 'app_setting_provider.dart';

class NavbarWithReturnButton extends StatelessWidget implements PreferredSizeWidget {
  final double fontSize;
  final double buttonIconsSize;

  const NavbarWithReturnButton(
      {super.key, required this.fontSize, required this.buttonIconsSize});

  @override
  //24 is the padding (horizontal +vertical) of the navbar
  Size get preferredSize => Size.fromHeight(max(buttonIconsSize, fontSize) + 24);

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingProvider>(context);

    return Container(
      color: Color.fromRGBO(18, 18, 18, 1.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8.0),
        child: Stack(
          children: [
            // Left side - Back button, fixed position
            Positioned(
              left: 0,
              child: IconButton(
                icon: Icon(Icons.arrow_back,
                    color: Colors.white, size: buttonIconsSize),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            // Centered Title (GradientText) in the middle
            Center(
              child: GradientText(
                "SteadyEye",
                style: TextStyle(
                    fontSize: fontSize, fontFamily: settings.fontFamily),
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
}
