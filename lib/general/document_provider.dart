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
  Map<String, double> _bookmarkedPositions = {}; // Stores bookmarked positions

  DocumentProvider() {
    _loadDocuments(); // Load saved documents on startup
  }

  /// **Save Scroll Position (Auto)**
  Future<void> saveScrollPosition(String documentName, double position) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('scroll_$documentName', position);
    _scrollPositions[documentName] = position;
  }

  /// **Get Last Scroll Position**
  Future<double> getScrollPosition(String documentName) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('scroll_$documentName') ?? 0.0; // Default to top
  }

  /// **Save Bookmark (Only When Pressing Bookmark Button)**
  Future<void> saveBookmarkedPosition(String documentName, double position) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('bookmark_$documentName', position);
    _bookmarkedPositions[documentName] = position;
  }

  /// **Get Last Bookmarked Position**
  Future<double> getBookmarkedPosition(String documentName) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('bookmark_$documentName') ?? 0.0; // Default to top
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
  void addDocument(String name, String path) async {
    int existingIndex = _documents.indexWhere((doc) => doc.name == name);

    if (existingIndex != -1) {
      _documents[existingIndex] = Document(name: name, path: path);
    } else {
      _documents.add(Document(name: name, path: path));
    }

    notifyListeners();
    _saveDocuments();
  }

  /// **Save Document List to SharedPreferences**
  Future<void> _saveDocuments() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> documentJsonList = _documents.map((doc) => jsonEncode(doc.toJson())).toList();
    await prefs.setStringList('saved_documents', documentJsonList);
  }

  /// **Load Saved Documents from SharedPreferences**
  Future<void> _loadDocuments() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedDocs = prefs.getStringList('saved_documents');

    if (savedDocs != null) {
      _documents = savedDocs.map((doc) => Document.fromJson(jsonDecode(doc))).toList();
      notifyListeners();
    }
  }
}
