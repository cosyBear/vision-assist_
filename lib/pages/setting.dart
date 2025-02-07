import 'package:flutter/material.dart';
import 'package:steady_eye_2/wigdt%20/logo.dart';
import '../pages/text_size_fonts.dart';

class GlobalSetting extends StatelessWidget {
  const GlobalSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TextSizeFonts()));
                  },
                  style: TextButton.styleFrom(backgroundColor: Colors.white),
                  child: Text(
                    "Text Size & Fonts",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  )),
            ],
          ),
          Logo(),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  ;
                },
                child: Text(
                  "Background & Text Color",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
