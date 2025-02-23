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

  Map<String, double> _scrollPositions = {}; // Store document scroll positions


  Future<void> saveScrollPosition(String documentName, double position) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('scroll_$documentName', position);
    _scrollPositions[documentName] = position;
  }

  Future<double> getScrollPosition(String documentName) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('scroll_$documentName') ?? 0.0; // Default to top of document
  }

  // Method to get the document path by its name
  String? getDocumentPath(String name) {
    // Search for a document with the matching name
    final document = _documents.firstWhere(
          (doc) => doc.name == name,
      orElse: () => Document(name: "", path: ""), // Return a dummy Document instead of null
    );

    // If the document's path is empty, return null
    if (document.name.isEmpty) {
      return null;
    }

    return document.path;
  }


  DocumentProvider() {
    _loadDocuments(); // Load saved documents on startup
  }

  // Add or replace a document and save it
  void addDocument(String name, String path) async {
    int existingIndex = _documents.indexWhere((doc) => doc.name == name);

    if (existingIndex != -1) {
      // Replace existing document
      _documents[existingIndex] = Document(name: name, path: path);
    } else {
      // Add new document
      _documents.add(Document(name: name, path: path));
    }

    notifyListeners();
    _saveDocuments(); // Save updated list to SharedPreferences
  }


  // Save document list to SharedPreferences
  Future<void> _saveDocuments() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> documentJsonList = _documents.map((doc) => jsonEncode(doc.toJson())).toList();
    await prefs.setStringList('saved_documents', documentJsonList);
  }

  // Load saved document list from SharedPreferences
  Future<void> _loadDocuments() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedDocs = prefs.getStringList('saved_documents');

    if (savedDocs != null) {
      _documents = savedDocs.map((doc) => Document.fromJson(jsonDecode(doc))).toList();
      notifyListeners(); // Notify UI of the loaded data
    }
  }
}
