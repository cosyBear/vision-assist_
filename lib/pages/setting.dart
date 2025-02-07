import 'package:flutter/material.dart';
import 'package:steady_eye_2/wigdt/logo.dart';
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
      Row(
        children: [
          SizedBox(width: MediaQuery.of(context).size.width * 0.1),
          Image.asset(
            'assets/images/logo.png',
            width: MediaQuery.of(context).size.width * 0.3, // 30% of screen width
            height: MediaQuery.of(context).size.width * 0.3, // Maintain proportional height
          ),
        ],
      ),
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
