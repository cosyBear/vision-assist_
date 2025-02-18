import 'package:flutter/material.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            category,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...books.map(
              (title) => ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey[800],
              child: Text((books.indexOf(title) + 1).toString()),
            ),
            title: Text(title, style: const TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}
