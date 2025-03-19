import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:SteadyEye/general/app_localizations.dart';

class BookmarkDialog extends StatefulWidget {
  final List<Map<String, dynamic>> bookmarks;
  final Function(String bookmarkName) onAddBookmark;
  final Function(double bookmarkPosition) onDeleteBookmark;
  final ScrollController scrollController;
  final double fontSize;
  final String fontFamily;
  final double buttonIconSize;
  final String bookmarksTitle;
  final String noBookmarksText;
  final String addBookmarkText;

  const BookmarkDialog({
    super.key,
    required this.bookmarks,
    required this.onAddBookmark,
    required this.onDeleteBookmark,
    required this.scrollController,
    required this.fontSize,
    required this.fontFamily,
    required this.buttonIconSize,
    required this.bookmarksTitle,
    required this.noBookmarksText,
    required this.addBookmarkText,
  });

  @override
  _BookmarkDialogState createState() => _BookmarkDialogState();
}

class _BookmarkDialogState extends State<BookmarkDialog> {

  final GlobalKey _addButtonKey = GlobalKey();
  final GlobalKey _deleteButtonKey = GlobalKey();
  // New key for the bookmark name text field.
  final GlobalKey _bookmarkNameFieldKey = GlobalKey();
  TutorialCoachMark? tutorialCoachMark;
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkAndShowTutorial();
  }

  Future<void> _checkAndShowTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    bool tutorialShown = prefs.getBool('bookmarkTutorialShown') ?? false;
    if (!tutorialShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showDialogTutorial();
      });
      prefs.setBool('bookmarkTutorialShown', true);
    }
  }

  void _showDialogTutorial() {
    List<TargetFocus> targets = [];

    // Target for the bookmark name input field.
    targets.add(
      TargetFocus(
        identify: "BookmarkNameField",
        keyTarget: _bookmarkNameFieldKey,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        paddingFocus: 10.0,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.black.withValues(alpha: 0.7),
              child: Text(
                context.tr("BookMarkName"),
                style: TextStyle(fontSize: widget.fontSize, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );

    // Target for the Add Button.
    targets.add(
      TargetFocus(
        identify: "AddButton",
        keyTarget: _addButtonKey,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        paddingFocus: 10.0,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.black.withValues(alpha: 0.7),
              child: Text(
                context.tr("AddBookMark"),
                style: TextStyle(fontSize: widget.fontSize, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );

    // Target for the Delete Button.
    if (widget.bookmarks.isNotEmpty) {
      targets.add(
        TargetFocus(
          identify: "DeleteButton",
          keyTarget: _deleteButtonKey,
          shape: ShapeLightFocus.RRect,
          radius: 8,
          paddingFocus: 10.0,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.black.withValues(alpha: 0.7),
                child: Text(
                    context.tr("DeleteBookMark"),
                  style: TextStyle(fontSize: widget.fontSize, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      );
    }

    tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      onFinish: () {
        debugPrint('Dialog tutorial finished');
        return true;
      },
      onSkip: () {
        debugPrint('Dialog tutorial skipped');
        return true;
      },
    );
    tutorialCoachMark?.show(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.bookmarksTitle,
                style: TextStyle(
                  fontSize: widget.fontSize * 1.3,
                  fontFamily: widget.fontFamily,
                  color: const Color.fromRGBO(203, 105, 156, 1.0),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.black, size: widget.buttonIconSize),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width / 1.2,
            child: Scrollbar(
              thumbVisibility: true,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    widget.bookmarks.isEmpty
                        ? Text(
                        widget.noBookmarksText,
                        style: TextStyle(
                            fontSize: widget.fontSize,
                            fontFamily: widget.fontFamily
                        ))
                        : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: widget.bookmarks.asMap().entries.map((entry) {
                        int index = entry.key;
                        Map<String, dynamic> bookmark = entry.value;
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                          child: ListTile(
                            title: Text(
                              "${bookmark['name']}",
                              style: TextStyle(fontSize: widget.fontSize, fontFamily: widget.fontFamily),
                            ),
                            trailing: IconButton(
                              key: index == 0 ? _deleteButtonKey : null,
                              icon: Icon(Icons.delete, color: Colors.red, size: widget.buttonIconSize),
                              onPressed: () {
                                widget.onDeleteBookmark(bookmark['position']);
                                Navigator.pop(context);
                              },
                            ),
                            onTap: () {
                              widget.scrollController.jumpTo(bookmark['position']);
                              Navigator.pop(context);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                    // Updated TextField with GlobalKey, hint text, and clear icon.
                    TextField(
                      key: _bookmarkNameFieldKey,
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Bookmark Name",
                        hintText: "Enter bookmark name",
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => nameController.clear(),
                        ),
                        labelStyle: TextStyle(fontSize: widget.fontSize, fontFamily: widget.fontFamily),
                      ),
                      style: TextStyle(fontSize: widget.fontSize, fontFamily: widget.fontFamily),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              key: _addButtonKey,
              onPressed: () {
                String bookmarkName = nameController.text.isNotEmpty
                    ? nameController.text
                    : "Bookmark ${widget.bookmarks.length + 1}";
                widget.onAddBookmark(bookmarkName);
                Navigator.pop(context);
              },
              child: Text(
                widget.addBookmarkText,
                style: TextStyle(
                    color: const Color.fromRGBO(22, 173, 201, 1.0),
                    fontSize: widget.fontSize,
                    fontFamily: widget.fontFamily
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
