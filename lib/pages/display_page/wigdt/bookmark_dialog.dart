import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

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
    Key? key,
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
  }) : super(key: key);

  @override
  _BookmarkDialogState createState() => _BookmarkDialogState();
}

class _BookmarkDialogState extends State<BookmarkDialog> {
  final GlobalKey _addButtonKey = GlobalKey();
  final GlobalKey _deleteButtonKey = GlobalKey();
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
              color: Colors.black.withOpacity(0.7),
              child: Text(
                "Tap here to add a new bookmark.",
                style: TextStyle(fontSize: widget.fontSize, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );

    // Target for the Delete Button.
    // We assign the global key only to the first delete button.
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
                color: Colors.black.withOpacity(0.7),
                child: Text(
                  "Tap here to delete a bookmark.",
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
    return AlertDialog(
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
                    ? Text(widget.noBookmarksText)
                    : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.bookmarks.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> bookmark = entry.value;
                    return ListTile(
                      title: Text(
                        "${bookmark['name']}",
                        style: TextStyle(
                            fontSize: widget.fontSize, fontFamily: widget.fontFamily),
                      ),
                      trailing: IconButton(
                        // Assign the global key only to the first delete button.
                        key: index == 0 ? _deleteButtonKey : null,
                        icon: Icon(Icons.delete,
                            color: Colors.red, size: widget.buttonIconSize),
                        onPressed: () {
                          widget.onDeleteBookmark(bookmark['position']);
                          Navigator.pop(context);
                        },
                      ),
                      onTap: () {
                        widget.scrollController.jumpTo(bookmark['position']);
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Bookmark Name",
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
            style: TextStyle(color: const Color.fromRGBO(22, 173, 201, 1.0), fontSize: widget.fontSize),
          ),
        ),
      ],
    );
  }
}
