import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'package:SteadyEye/pages/library_page/wigdt/book_list.dart';
import 'package:SteadyEye/pages/library_page/wigdt/search_bar.dart';
import '../../general/document_provider.dart';
import '../../../general/app_setting_provider.dart';
import 'package:SteadyEye/general/app_localizations.dart';

class Library extends StatefulWidget {
  final void Function(int) goToPage; // Function to change pages

  const Library({super.key, required this.goToPage});

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  TextEditingController searchController = TextEditingController();
  List<String> filteredBooks = [];

  // GlobalKeys for tutorial targets
  final GlobalKey _searchBarKey = GlobalKey();
  final GlobalKey _bookListKey = GlobalKey();
  final GlobalKey _addButtonKey = GlobalKey();

  TutorialCoachMark? tutorialCoachMark;

  @override
  void initState() {
    super.initState();
    filteredBooks = [];

    // Delay tutorial start to prevent UI misalignment
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 1), () {
        _showTutorialIfNeeded();
      });
    });
  }

  /// Checks if the tutorial has been shown before
  Future<void> _showTutorialIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    bool hasShown = prefs.getBool('libraryPageTutorialShown') ?? false;
    if (!hasShown) {
      _showTutorial();
      await prefs.setBool('libraryPageTutorialShown', true);
    }
  }

  void _showTutorial() {
    final settings = Provider.of<AppSettingProvider>(context, listen: false);

    double screenWidth = MediaQuery.of(context).size.width;
    double buttonIconsSize = settings.buttonIconsSize;

    if (screenWidth < 1000) {
      buttonIconsSize =
      settings.buttonIconsSize > 60 ? 60 : settings.buttonIconsSize;
    }
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      alignSkip: Alignment.topRight, // Moves "Skip" to the bottom
      textSkip: "Skip Tutorial", // Customize text
      paddingFocus: 10, // Add some padding around the highlight
      skipWidget: Padding(
        padding: const EdgeInsets.only(top: 30, right:10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(buttonIconsSize * 0.4),
              side: BorderSide(color: Color.fromRGBO(203, 105, 156, 1), width: buttonIconsSize / 15),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16), // Increased padding
            textStyle: TextStyle(fontSize: buttonIconsSize * 0.8, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            tutorialCoachMark?.skip();
          },
          child: const Text("Next", style: TextStyle(color: Colors.white)),
        ),
      ),
      onFinish: () {
        debugPrint("Tutorial finished");
        return true;
      },
      onSkip: () {
        debugPrint("Tutorial skipped");
        return false;
      },
    );

    tutorialCoachMark?.show(context: context);
  }

  /// Defines the tutorial steps for UI elements
  List<TargetFocus> _createTargets() {
    return [
      // 1️⃣ Search Bar
      TargetFocus(
        identify: "SearchBar",
        keyTarget: _searchBarKey,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: _buildTooltip(
              context.tr('searchTitle'),
              context.tr('searchInstructions'),
            ),
          ),
        ],
      ),
      // 2️⃣ Book List
      TargetFocus(
        identify: "BookList",
        keyTarget: _bookListKey,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            padding: const EdgeInsets.only(top: 50),
            align: ContentAlign.top,
            child: _buildTooltip(
              context.tr('libraryTitle'),
              context.tr('libraryInstructions'),
            ),
          ),
        ],
      ),
      // 3️⃣ Add Button
      TargetFocus(
        identify: "AddButton",
        keyTarget: _addButtonKey,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: _buildTooltip(
              context.tr('addButtonTitle'),
              context.tr('addButtonInstructions'),
            ),
          ),
        ],
      ),
    ];
  }

  /// Helper widget for tutorial tooltips
  Widget _buildTooltip(String title, String description) {
    final settings = Provider.of<AppSettingProvider>(context, listen: false);
    return Container(
      padding: const EdgeInsets.all(8.0),
      color:Colors.black.withValues(alpha: (0.7 * 255)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: settings.fontSize,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(color: Colors.white,  fontSize: settings.fontSize),
          ),
        ],
      ),
    );
  }

  /// Groups books alphabetically by the first letter
  Map<String, List<String>> groupBooksByCategory(List<String> books) {
    Map<String, List<String>> categorizedBooks = {};
    for (String book in books) {
      String firstLetter = book[0].toUpperCase();
      categorizedBooks.putIfAbsent(firstLetter, () => []).add(book);
    }
    return categorizedBooks;
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingProvider>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonIconsSize = settings.buttonIconsSize;
    Color iconColor = settings.textColor;

    if (screenWidth < 1000) {
      buttonIconsSize = settings.buttonIconsSize > 60 ? 60 : settings.buttonIconsSize;
    }

    final documentProvider = Provider.of<DocumentProvider>(context);
    List<String> books = documentProvider.documents.map((doc) => doc.name).toList();

    // If there's a filter applied, use filteredBooks; otherwise, show all books
    List<String> booksToDisplay = filteredBooks.isEmpty ? books : filteredBooks;
    booksToDisplay.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    Map<String, List<String>> categorizedBooks = groupBooksByCategory(booksToDisplay);

    return Scaffold(
      backgroundColor: settings.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Row(
                  children: [
                    // Search Bar (With GlobalKey for tutorial)
                    Expanded(
                      child: Container(
                        key: _searchBarKey,
                        child: SearchBarWidget(
                          searchController: searchController,
                          onSearch: (query) {
                            setState(() {
                              filteredBooks = books
                                  .where((book) => book.toLowerCase().contains(query.toLowerCase()))
                                  .toList();
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      key: _addButtonKey,
                      icon: Icon(Icons.add_circle_outline, size: buttonIconsSize, color: iconColor),
                      onPressed: () => widget.goToPage(1),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Use Flexible here as well
                Flexible(
                  fit: FlexFit.loose,
                  child: Container(
                    key: _bookListKey,
                    child: BookList(categorizedBooks: categorizedBooks),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
