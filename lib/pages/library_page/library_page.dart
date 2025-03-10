import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'package:steady_eye_2/pages/library_page/wigdt/book_list.dart';
import 'package:steady_eye_2/pages/library_page/wigdt/search_bar.dart';
import '../../general/document_provider.dart';
import '../../../general/app_setting_provider.dart';

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

  /// Displays the tutorial with highlighted UI elements
  void _showTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      alignSkip: Alignment.topRight,
      onFinish: () {
        debugPrint('Tutorial finished');
        return true;
      },
      onSkip: () {
        debugPrint('Tutorial skipped');
        return true;
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
        paddingFocus: 10.0,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: _buildTooltip(
              "Search for Books",
              "Use the search bar to quickly find books by name.",
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
        paddingFocus: 10.0,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: _buildTooltip(
              "Your Library",
              "All books are listed here, grouped alphabetically.",
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
        paddingFocus: 10.0,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: _buildTooltip(
              "Add a New Book",
              "Tap the '+' button to upload a new document.",
            ),
          ),
        ],
      ),
    ];
  }

  /// Helper widget for tutorial tooltips
  Widget _buildTooltip(String title, String description) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.black.withOpacity(0.7),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(color: Colors.white),
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                // Search Bar (With GlobalKey for tutorial)
                Expanded(
                  child: Container(
                    key: _searchBarKey, // Attach key
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

                // Plus Button (With GlobalKey for tutorial)
                IconButton(
                  key: _addButtonKey, // Attach key
                  icon: Icon(Icons.add_circle_outline, size: buttonIconsSize, color: Colors.grey),
                  onPressed: () => widget.goToPage(1), // Navigate to Upload Page
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Book List (With GlobalKey for tutorial)
            Expanded(
              child: Container(
                key: _bookListKey, // Attach key
                child: BookList(categorizedBooks: categorizedBooks),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
