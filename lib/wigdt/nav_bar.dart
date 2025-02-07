import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  final void Function(int) onIconPressed;

  const Navbar({super.key, required this.onIconPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      backgroundColor: const Color.fromRGBO(18, 18, 18, 1.0),
      // Black background
      leading: IconButton(
        icon: const Icon(Icons.home, color: Colors.white, size: 40),
        // White icon
        onPressed: () => onIconPressed(0),
      ),
      title: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Centers the content
          mainAxisSize: MainAxisSize.max, // Makes the Row take minimal width
        children:[
          const SizedBox(width: 100),
          GradientText(
          "SteadyEye",
          style: const TextStyle(fontSize: 40),
          colors: const [
            Color.fromRGBO(203, 105, 156, 1.0),
            Color.fromRGBO(22, 173, 201, 1.0),
          ],
        ),
        ]
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.local_library_rounded,
              color: Colors.white, size: 40),
          onPressed: () => onIconPressed(1),
        ),
        IconButton(
          icon: const Icon(Icons.cloud_upload_outlined,
              color: Colors.white, size: 40),
          onPressed: () => onIconPressed(22),
        ),
        IconButton(onPressed: () => onIconPressed(2), icon: Icon(Icons.settings , color: Colors.white, size: 40)),
      ],
    ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
