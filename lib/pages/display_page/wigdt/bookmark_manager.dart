import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../general/app_setting_provider.dart';
import '../../../general/document_provider.dart';
import 'package:steady_eye_2/general/app_localizations.dart';

class BookmarkManager extends StatelessWidget {
  final String? documentName;
  final ScrollController scrollController;
  final VoidCallback onBookmarkPressed;


  const BookmarkManager({
    required this.documentName,
    required this.scrollController,
    required this.onBookmarkPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (documentName == null) {
      return const SizedBox.shrink();
    }

    final documentProvider =
    Provider.of<DocumentProvider>(context, listen: false);
    final settings = Provider.of<AppSettingProvider>(context, listen: false);
    Color textColor = settings.textColor;

    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = settings.fontSize;
    double buttonIconsSize = settings.buttonIconsSize;

    if (screenWidth < 1000) {
      fontSize = settings.fontSize > 40 ? 40 : settings.fontSize;
      buttonIconsSize =
      settings.buttonIconsSize > 60 ? 60 : settings.buttonIconsSize;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      List<Map<String, dynamic>> bookmarks =
      await documentProvider.getBookmarks(documentName!);
      if (!bookmarks.any((bookmark) => bookmark['position'] == 0.0)) {
        documentProvider.addBookmark(documentName!, 0.0, name: "Start");
      }
    });

    return IconButton(
      icon: Icon(
        Icons.bookmarks,
        size: buttonIconsSize,
        color: textColor,
      ),
      onPressed: () {
        onBookmarkPressed();
        _showBookmarkDialog(context, fontSize, settings.fontFamily, buttonIconsSize);
      },
    );
  }

  void _showBookmarkDialog(BuildContext context, double fontSize,
      String fontFamily, double buttonIconSize) async {
    final documentProvider = Provider.of<DocumentProvider>(context, listen: false);
    List<Map<String, dynamic>> bookmarks = await documentProvider.getBookmarks(documentName!);

    TextEditingController nameController = TextEditingController();

    // Create a new ScrollController for the dialog
    ScrollController dialogScrollController = ScrollController();

    double screenWidth = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
          context.tr('bookmarksTitle'),
                style: TextStyle(
                    fontSize: fontSize * 1.3,
                    fontFamily: fontFamily,
                    color: Color.fromRGBO(203, 105, 156, 1.0)),
              ),
              IconButton(
                icon: Icon(Icons.close,
                    color: Colors.black, size: buttonIconSize),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          // Wrap content with Container to set a custom width
          content: Container(
            width: screenWidth/2,
            child: Scrollbar(
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: dialogScrollController, // Use the new controller
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    bookmarks.isEmpty
                        ?  Text(context.tr('noBookmarks'))
                        : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: bookmarks.map((bookmark) {
                        return ListTile(
                          title: Text(
                            "${bookmark['name']}",
                            style: TextStyle(
                                fontSize: fontSize,
                                fontFamily: fontFamily),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete,
                                color: Colors.red, size: buttonIconSize),
                            onPressed: () {
                              documentProvider.removeBookmark(
                                  documentName!, bookmark['position']);
                              Navigator.pop(context);
                              _showBookmarkDialog(context, fontSize,
                                  fontFamily, buttonIconSize);
                            },
                          ),
                          onTap: () {
                            scrollController.jumpTo(bookmark['position']);
                            Navigator.pop(context);
                          },
                        );
                      }).toList(),
                    ),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                          labelText: context.tr('nameBookmarks'),
                          labelStyle: TextStyle(
                              fontSize: fontSize, fontFamily: fontFamily)),
                      style: TextStyle(
                          fontSize: fontSize, fontFamily: fontFamily),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                String bookmarkName = nameController.text.isNotEmpty
                    ? nameController.text
                    : "Bookmark ${bookmarks.length + 1}";
                documentProvider.addBookmark(
                    documentName!, scrollController.offset,
                    name: bookmarkName);
                Navigator.pop(context);
                _showBookmarkDialog(
                    context, fontSize, fontFamily, buttonIconSize);
              },
              child: Text(
              context.tr('addBookmark'),
                style: TextStyle(
                    color: Color.fromRGBO(22, 173, 201, 1.0),
                    fontSize: fontSize),
              ),
            ),
          ],
        );
      },
    );
  }

}
