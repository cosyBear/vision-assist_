import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../general/app_setting_provider.dart';
import '../../../general/document_provider.dart';

class BookmarkManager extends StatelessWidget {
  final String? documentName;
  final ScrollController scrollController;

  const BookmarkManager({
    required this.documentName,
    required this.scrollController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (documentName == null) {
      return const SizedBox.shrink(); // Hide if no document name
    }

    final documentProvider =
    Provider.of<DocumentProvider>(context, listen: false);
    final settings = Provider.of<AppSettingProvider>(context, listen: false);
    Color textColor = settings.textColor;

    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double fontSize = settings.fontSize;
    double buttonIconsSize = settings.buttonIconsSize;

    if (screenWidth < 1000) {
      fontSize = settings.fontSize > 40 ? 40 : settings.fontSize;
      buttonIconsSize =
      settings.buttonIconsSize > 60 ? 60 : settings.buttonIconsSize;
    }

    // Ensure an initial bookmark at position 0.0
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      List<double> bookmarks =
      await documentProvider.getBookmarks(documentName!);
      if (!bookmarks.contains(0.0)) {
        documentProvider.addBookmark(documentName!, 0.0);
      }
    });

    return IconButton(
      icon: Icon(
        Icons.bookmarks,
        size: buttonIconsSize,
        color: textColor,
      ),
      onPressed: () =>
          _showBookmarkDialog(
              context, fontSize, settings.fontFamily, buttonIconsSize),
    );
  }

  void _showBookmarkDialog(BuildContext context, double fontSize,
      String fontFamily, double buttonIconSize) async {
    final documentProvider =
    Provider.of<DocumentProvider>(context, listen: false);
    List<double> bookmarks = await documentProvider.getBookmarks(documentName!);
    int index = 0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Bookmarks",
                style: TextStyle(
                    fontSize: fontSize *1.3,
                    fontFamily: fontFamily,
                    color: Color.fromRGBO(203, 105, 156, 1.0)),
              ),
              IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.black,
                  size: buttonIconSize
                ),
                onPressed: () => Navigator.pop(context), // Close the dialog
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: bookmarks.isEmpty
                ? const Text("No bookmarks yet.")
                : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: bookmarks.map((position) {
                  index++;
                  return ListTile(
                    title: Text(
                      "Bookmark $index at position $position",
                      style: TextStyle(
                          fontSize: fontSize, fontFamily: fontFamily),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete,
                          color: Colors.red, size: buttonIconSize),
                      onPressed: () {
                        documentProvider.removeBookmark(
                            documentName!, position);
                        Navigator.pop(context);
                        _showBookmarkDialog(context, fontSize, fontFamily,
                            buttonIconSize); // Refresh dialog
                      },
                    ),
                    onTap: () {
                      scrollController.jumpTo(position);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                documentProvider.addBookmark(
                    documentName!, scrollController.offset);
                Navigator.pop(context);
                _showBookmarkDialog(context, fontSize, fontFamily,
                    buttonIconSize); // Refresh dialog to show the new bookmark
              },
              child: Text("Add Bookmark",
                  style: TextStyle(color: Color.fromRGBO(22, 173, 201, 1.0),
                      fontSize: fontSize)),
            ),
          ],
        );
      },
    );
  }
}
