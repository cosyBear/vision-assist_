import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Document {
  final String name;
  final String path;

  Document({required this.name, required this.path});

  // Convert Document to JSON
  Map<String, dynamic> toJson() => {'name': name, 'path': path};

  // Convert JSON to Document
  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(name: json['name'], path: json['path']);
  }
}

class DocumentProvider extends ChangeNotifier {
  List<Document> _documents = [];
  List<Document> get documents => _documents;

  Map<String, double> _scrollPositions = {}; // Stores document scroll positions
  Map<String, List<double>> _bookmarkedPositions = {}; // Store multiple bookmarks

  bool _loading = false;  // Track loading state
  bool get loading => _loading;

  DocumentProvider() {
    _loadDocuments(); // Load saved documents on startup
  }

  /// **Save Scroll Position (Auto)**
  Future<void> saveScrollPosition(String documentName, double position) async {
    _setLoading(true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('scroll_$documentName', position);
    _scrollPositions[documentName] = position;
    _setLoading(false);
    notifyListeners();
  }

  /// **Get Last Scroll Position**
  Future<double> getScrollPosition(String documentName) async {
    _setLoading(true);
    final prefs = await SharedPreferences.getInstance();
    double position = prefs.getDouble('scroll_$documentName') ?? 0.0; // Default to top
    _setLoading(false);
    return position;
  }

  /// **Save a New Bookmark**
  Future<void> addBookmark(String documentName, double position) async {
    _setLoading(true);
    final prefs = await SharedPreferences.getInstance();
    List<double> bookmarks = _bookmarkedPositions[documentName] ?? [];

    if (!bookmarks.contains(position)) { // Avoid duplicates
      bookmarks.add(position);
      _bookmarkedPositions[documentName] = bookmarks;  // Update in-memory list immediately
      await prefs.setString('bookmark_$documentName', jsonEncode(bookmarks)); // Save to SharedPreferences
    }
    _setLoading(false);
    notifyListeners();
  }

  /// **Remove a Bookmark**
  Future<void> removeBookmark(String documentName, double position) async {
    _setLoading(true);
    final prefs = await SharedPreferences.getInstance();
    List<double> bookmarks = _bookmarkedPositions[documentName] ?? [];

    bookmarks.remove(position);
    _bookmarkedPositions[documentName] = bookmarks;  // Update in-memory list immediately

    await prefs.setString('bookmark_$documentName', jsonEncode(bookmarks)); // Save to SharedPreferences
    _setLoading(false);
    notifyListeners();
  }

  /// **Get All Bookmarks for a Document**
  Future<List<double>> getBookmarks(String documentName) async {
    _setLoading(true);
    final prefs = await SharedPreferences.getInstance();
    String? bookmarksJson = prefs.getString('bookmark_$documentName');

    List<double> bookmarks = [];
    if (bookmarksJson != null) {
      List<dynamic> decoded = jsonDecode(bookmarksJson);
      _bookmarkedPositions[documentName] = decoded.cast<double>(); // Sync in-memory map with loaded data
      bookmarks = decoded.cast<double>();
    }
    _setLoading(false);
    return bookmarks;
  }

  /// **Get Document Path by Name**
  String? getDocumentPath(String name) {
    final document = _documents.firstWhere(
          (doc) => doc.name == name,
      orElse: () => Document(name: "", path: ""), // Dummy object to prevent null
    );
    return document.name.isEmpty ? null : document.path;
  }

  /// **Add or Replace a Document**
  Future<void> addDocument(String name, String path) async {
    _setLoading(true);
    int existingIndex = _documents.indexWhere((doc) => doc.name == name);

    if (existingIndex != -1) {
      // Document exists, replace it and reset bookmarks
      _documents[existingIndex] = Document(name: name, path: path);
      // Reset bookmarks for the replaced document
      _bookmarkedPositions[name] = [];
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('bookmark_$name'); // Remove bookmarks from SharedPreferences
    } else {
      _documents.add(Document(name: name, path: path));
    }

    _setLoading(false);
    notifyListeners();
    _saveDocuments();
  }

  /// **Save Document List to SharedPreferences**
  Future<void> _saveDocuments() async {
    _setLoading(true);
    final prefs = await SharedPreferences.getInstance();
    List<String> documentJsonList = _documents.map((doc) => jsonEncode(doc.toJson())).toList();
    await prefs.setStringList('saved_documents', documentJsonList);
    _setLoading(false);
  }

  /// **Load Saved Documents from SharedPreferences**
  Future<void> _loadDocuments() async {
    _setLoading(true);
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedDocs = prefs.getStringList('saved_documents');

    if (savedDocs != null) {
      _documents = savedDocs.map((doc) => Document.fromJson(jsonDecode(doc))).toList();
    }
    _setLoading(false);
    notifyListeners();
  }

  /// Helper method to set loading state
  void _setLoading(bool isLoading) {
    _loading = isLoading;
    notifyListeners();
  }
}
