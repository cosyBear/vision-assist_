import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:steady_eye_2/pages/library_page/wigdt/book_list.dart';
import 'package:steady_eye_2/pages/library_page/wigdt/search_bar.dart';
import '../../general/document_provider.dart';

class Library extends StatefulWidget {
  const Library({super.key});

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  TextEditingController searchController = TextEditingController();
  List<String> filteredBooks = []; // This is the list of filtered books

  @override
  void initState() {
    super.initState();
    filteredBooks = []; // Initially show all books
  }

  // Group books by category function
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
    final documentProvider = Provider.of<DocumentProvider>(context);
    List<String> books = documentProvider.documents.map((doc) => doc.name).toList(); // Extract names

    // If there's a filter applied, use filteredBooks. Otherwise, use all books.
    List<String> booksToDisplay = filteredBooks.isEmpty ? books : filteredBooks;

    // Sort books alphabetically
    booksToDisplay.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    // Group the sorted books by category
    Map<String, List<String>> categorizedBooks = groupBooksByCategory(booksToDisplay);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SearchBarWidget(
              searchController: searchController,
              onSearch: (query) {
                setState(() {
                  // Filter the books based on the query
                  filteredBooks = books
                      .where((book) => book.toLowerCase().contains(query.toLowerCase()))
                      .toList();
                });
              },
            ),
            const SizedBox(height: 20),
            Expanded(child: BookList(categorizedBooks: categorizedBooks)),
          ],
        ),
      ),
    );
  }
}
