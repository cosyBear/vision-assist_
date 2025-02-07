import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UploadText extends StatelessWidget {
  const UploadText({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
      child: Text(
        "Upload, insert or take a picture",
        style: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
