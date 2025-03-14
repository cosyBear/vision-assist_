import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../general/app_setting_provider.dart';
import '../../../general/document_provider.dart';
import 'package:SteadyEye/general/app_localizations.dart';
import 'bookmark_dialog.dart'; // Import the new BookmarkDialog widget

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

    final documentProvider = Provider.of<DocumentProvider>(context, listen: false);
    final settings = Provider.of<AppSettingProvider>(context, listen: false);
    Color textColor = settings.textColor;

    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = settings.fontSize;
    double buttonIconsSize = settings.buttonIconsSize;

    if (screenWidth < 1000) {
      fontSize = settings.fontSize > 40 ? 40 : settings.fontSize;
      buttonIconsSize = settings.buttonIconsSize > 60 ? 60 : settings.buttonIconsSize;
    }

    // Ensure a starting bookmark exists.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      List<Map<String, dynamic>> bookmarks = await documentProvider.getBookmarks(documentName!);
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

  void _showBookmarkDialog(BuildContext context, double fontSize, String fontFamily, double buttonIconSize) async {
    final documentProvider = Provider.of<DocumentProvider>(context, listen: false);
    List<Map<String, dynamic>> bookmarks = await documentProvider.getBookmarks(documentName!);

    showDialog(
      context: context,
      builder: (context) {
        return BookmarkDialog(
          bookmarks: bookmarks,
          scrollController: scrollController,
          fontSize: fontSize,
          fontFamily: fontFamily,
          buttonIconSize: buttonIconSize,
          bookmarksTitle: context.tr('bookmarksTitle'),
          noBookmarksText: context.tr('noBookmarks'),
          addBookmarkText: context.tr('addBookmark'),
          onAddBookmark: (String bookmarkName) {
            documentProvider.addBookmark(documentName!, scrollController.offset, name: bookmarkName);
          },
          onDeleteBookmark: (double position) {
            documentProvider.removeBookmark(documentName!, position);
          },
        );
      },
    );
  }
}
