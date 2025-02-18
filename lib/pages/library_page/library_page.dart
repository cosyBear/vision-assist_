import 'package:flutter/material.dart';
import 'package:steady_eye_2/pages/library_page/wigdt/book_list.dart';
import 'package:steady_eye_2/pages/library_page/wigdt/search_bar.dart';

/*
  This is the Library page. It displays a list of books that can be filtered by search query.
  The books are grouped by their first letter.
*/
class Library extends StatefulWidget {
  const Library({super.key});

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  TextEditingController searchController = TextEditingController();
  List<String> books = [
    'A Clockwork Orange',
    'A Wrinkle in Time',
    'Brave New World'
  ];
  List<String> filteredBooks = [];

  @override
  void initState() {
    super.initState();
    filteredBooks = books;
  }

  void filterBooks(String query) {
    setState(() {
      filteredBooks = books
          .where((book) => book.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

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
    Map<String, List<String>> categorizedBooks = groupBooksByCategory(filteredBooks);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SearchBarWidget(
            searchController: searchController,
            onSearch: filterBooks,
          ),
          const SizedBox(height: 20),
          BookList(categorizedBooks: categorizedBooks),
        ],
      ),
    );
  }
}
