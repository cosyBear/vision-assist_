import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Document {
  final String name;
  final String path;

  Document({required this.name, required this.path});

  Map<String, dynamic> toJson() => {'name': name, 'path': path};

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(name: json['name'], path: json['path']);
  }
}

class DocumentProvider extends ChangeNotifier {
  List<Document> _documents = [];
  List<Document> get documents => _documents;

  final Map<String, double> _scrollPositions = {};
  final Map<String, List<Map<String, dynamic>>> _bookmarkedPositions = {};

  bool _loading = false;
  bool get loading => _loading;

  DocumentProvider() {
    _loadDocuments();
  }

  Future<void> saveScrollPosition(String documentName, double position) async {
    _setLoading(true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('scroll_$documentName', position);
    _scrollPositions[documentName] = position;
    _setLoading(false);
    notifyListeners();
  }

  Future<double> getScrollPosition(String documentName) async {
    _setLoading(true);
    final prefs = await SharedPreferences.getInstance();
    double position = prefs.getDouble('scroll_$documentName') ?? 0.0;
    _setLoading(false);
    return position;
  }

  Future<void> addBookmark(String documentName, double position, {String? name}) async {
    _setLoading(true);
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> bookmarks = _bookmarkedPositions[documentName] ?? [];

    if (!bookmarks.any((bookmark) => bookmark['position'] == position)) {
      String bookmarkName = name ?? "Bookmark ${bookmarks.length + 1}";
      bookmarks.add({'position': position, 'name': bookmarkName});
      _bookmarkedPositions[documentName] = bookmarks;
      await prefs.setString('bookmark_$documentName', jsonEncode(bookmarks));
    }
    _setLoading(false);
    notifyListeners();
  }

  Future<void> removeBookmark(String documentName, double position) async {
    _setLoading(true);
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> bookmarks = _bookmarkedPositions[documentName] ?? [];

    bookmarks.removeWhere((bookmark) => bookmark['position'] == position);
    _bookmarkedPositions[documentName] = bookmarks;

    await prefs.setString('bookmark_$documentName', jsonEncode(bookmarks));
    _setLoading(false);
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getBookmarks(String documentName) async {
    _setLoading(true);
    final prefs = await SharedPreferences.getInstance();
    String? bookmarksJson = prefs.getString('bookmark_$documentName');

    List<Map<String, dynamic>> bookmarks = [];
    if (bookmarksJson != null) {
      List<dynamic> decoded = jsonDecode(bookmarksJson);
      _bookmarkedPositions[documentName] = decoded.cast<Map<String, dynamic>>();
      bookmarks = decoded.cast<Map<String, dynamic>>();
    }
    _setLoading(false);
    return bookmarks;
  }

  String? getDocumentPath(String name) {
    final document = _documents.firstWhere(
          (doc) => doc.name == name,
      orElse: () => Document(name: "", path: ""),
    );
    return document.name.isEmpty ? null : document.path;
  }

  Future<void> addDocument(String name, String path) async {
    _setLoading(true);
    int existingIndex = _documents.indexWhere((doc) => doc.name == name);

    if (existingIndex != -1) {
      _documents[existingIndex] = Document(name: name, path: path);
      _bookmarkedPositions[name] = [];
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('bookmark_$name');
    } else {
      _documents.add(Document(name: name, path: path));
    }

    _setLoading(false);
    notifyListeners();
    _saveDocuments();
  }

  Future<void> _saveDocuments() async {
    _setLoading(true);
    final prefs = await SharedPreferences.getInstance();
    List<String> documentJsonList = _documents.map((doc) => jsonEncode(doc.toJson())).toList();
    await prefs.setStringList('saved_documents', documentJsonList);
    _setLoading(false);
  }

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

  void _setLoading(bool isLoading) {
    _loading = isLoading;
    notifyListeners();
  }
}
