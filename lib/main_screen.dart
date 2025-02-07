import 'package:flutter/material.dart';
import 'upload_page/upload_page.dart';
import 'navbar.dart';
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() {
    return _MainScreenState();
  }
}



class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController();

  // This function animates to the given page index.
  void _goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: Navbar(onIconPressed: _goToPage),
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          physics: const PageScrollPhysics(),
          children: [
            const UploadPage(),
            // Add more pages if needed
          ],
        ),

      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => _goToPage(0),
      //   child: const Icon(Icons.arrow_upward),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
