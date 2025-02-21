import 'package:flutter/material.dart';
import 'book_category.dart';

/*
  This widget maps each book to its first letter and groups them by category.
  It uses the BookCategory widget for this purpose.
 */
class BookList extends StatelessWidget {
  final Map<String, List<String>> categorizedBooks;

  const BookList({super.key, required this.categorizedBooks});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: categorizedBooks.entries
            .map((entry) => BookCategory(category: entry.key, books: entry.value))
            .toList(),
      ),
    );
  }
}
