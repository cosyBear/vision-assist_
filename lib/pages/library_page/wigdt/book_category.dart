import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../general/app_setting_provider.dart';
import 'file_processor.dart';

/*
  This widget displays a category of books with their titles.
  The category is displayed as the first letter of the book title.
 */

class BookCategory extends StatelessWidget {
  final String category;
  final List<String> books;

  const BookCategory({
    super.key,
    required this.category,
    required this.books,
  });

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingProvider>(context);
    double fontSize = settings.fontSize;
    Color textColor = settings.textColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            category,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontFamily: settings.fontFamily,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...books.map(
              (title) => FileProcessorWidget(documentName: title), // Use FileProcessorWidget for each book
        ),
      ],
    );
  }
}
