import 'dart:developer';
import 'dart:io';
import 'package:archive/archive.dart'; // For extracting .docx (which is a zip file)
import 'package:epubx/epubx.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:xml/xml.dart'; // For parsing XML inside .docx files
import 'package:file_picker/file_picker.dart';
import 'package:markdown/markdown.dart' as md;

class DocumentHandler {
  static final DocumentHandler _instance = DocumentHandler._internal();
  DocumentHandler._internal();
  factory DocumentHandler() => _instance;

  // Store information about the last selected file.
  String? lastSelectedFilePath;
  String? lastSelectedFileName;

  /// Picks a document (PDF, DOCX, TXT, MD, EPUB) and returns its path.
  Future<String?> pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'txt', 'docx', 'md', 'epub'],
    );

    if (result != null && result.files.single.path != null) {
      lastSelectedFilePath = result.files.single.path;
      lastSelectedFileName = lastSelectedFilePath!.split('/').last;
      return lastSelectedFilePath;
    }
    return null;
  }

  /// Extracts text based on file extension.
  Future<String?> extractText(String filePath) async {
    if (filePath.endsWith('.pdf')) {
      return await extractTextFromPdf(filePath);
    } else if (filePath.endsWith('.txt')) {
      return await extractTextFromTxt(filePath);
    } else if (filePath.endsWith('.docx')) {
      return await extractTextFromDocx(filePath);
    } else if (filePath.endsWith('.md')) {
      return await extractTextFromMd(filePath);
    } else if (filePath.endsWith('.epub')) {
      return await extractTextFromEpub(filePath);
    } else {
      log("Unsupported file format!");
      return null;
    }
  }

  /// Picks a document and automatically extracts its text.
  Future<String?> pickAndExtractText() async {
    try {
      String? filePath = await pickDocument();
      if (filePath == null) {
        print("No file selected.");
        return null;
      }
      return await extractText(filePath);
    } catch (e) {
      print("Error picking and extracting text: $e");
      return null;
    }
  }

  // --- The extraction methods remain the same ---

  Future<String?> extractTextFromDocx(String filePath) async {
    try {
      File file = File(filePath);
      List<int> bytes = await file.readAsBytes();
      Archive archive = ZipDecoder().decodeBytes(bytes);

      for (var file in archive) {
        if (file.name == 'word/document.xml') {
          String xmlContent = String.fromCharCodes(file.content);
          final document = XmlDocument.parse(xmlContent);
          String extractedText = '';
          var body = document.findAllElements('w:t');
          for (var element in body) {
            extractedText += element.text;
          }
          return extractedText;
        }
      }
      return null;
    } catch (e) {
      print("Error extracting DOCX text: $e");
      return null;
    }
  }

  Future<String?> extractTextFromPdf(String filePath) async {
    try {
      File file = File(filePath);
      List<int> bytes = await file.readAsBytes();
      final PdfDocument document = PdfDocument(inputBytes: bytes);
      int pageCount = document.pages.count;
      String extractedText = '';

      for (int i = 0; i < pageCount; i++) {
        extractedText += '\n--- Page ${i + 1} ---\n';
        extractedText += PdfTextExtractor(document)
            .extractText(startPageIndex: i, endPageIndex: i);
      }
      document.dispose();
      return extractedText;
    } catch (e) {
      print("Error extracting PDF text: $e");
      return null;
    }
  }

  Future<String?> extractTextFromTxt(String filePath) async {
    try {
      return await File(filePath).readAsString();
    } catch (e) {
      print("Error extracting TXT text: $e");
      return null;
    }
  }

  Future<String?> extractTextFromMd(String filePath) async {
    try {
      String markdownContent = await File(filePath).readAsString();
      String document = md.markdownToHtml(markdownContent);
      return document.replaceAll(RegExp(r'<[^>]*>'), '');
    } catch (e) {
      log("Error extracting Markdown text: $e");
      return null;
    }
  }

  Future<String?> extractTextFromEpub(String filePath) async {
    try {
      File file = File(filePath);
      List<int> bytes = await file.readAsBytes();
      var epubBook = await EpubReader.readBook(bytes);
      String extractedText = '';

      if (epubBook.Chapters != null) {
        for (var chapter in epubBook.Chapters!) {
          String chapterContent = chapter.HtmlContent ?? '';
          String plainText = _removeHtmlTags(chapterContent);
          extractedText += plainText;
        }
        extractedText = _removeExcessWhitespace(extractedText);
      }
      return extractedText.isNotEmpty ? extractedText : null;
    } catch (e) {
      log("Error extracting EPUB text: $e");
      return null;
    }
  }

  String _removeHtmlTags(String html) {
    final regex = RegExp(r'<[^>]*>');
    return html.replaceAll(regex, '');
  }

  String _removeExcessWhitespace(String text) {
    String cleanedText = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    return cleanedText.replaceAll(RegExp(r'&nbsp;'), ' ');
  }
}
