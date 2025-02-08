import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../wigdt/app_setting_provider.dart';
import 'package:provider/provider.dart';

class UploadText extends StatelessWidget {
  const UploadText({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingProvider>(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
      child: Text(
        "Upload, insert or take a picture",
        style:  TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color:settings.textColor,
        ),
      ),
    );
  }
}
