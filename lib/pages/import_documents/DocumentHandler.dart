import 'dart:io';
import 'package:archive/archive.dart'; // For extracting .docx (which is a zip file)
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:xml/xml.dart'; // For parsing XML inside .docx files
import 'package:file_picker/file_picker.dart';

class DocumentHandler {
  static final DocumentHandler _instance = DocumentHandler._internal();

  DocumentHandler._internal();

  // Factory constructor to return the same instance
  factory DocumentHandler() => _instance;

  /// Picks a document (PDF, DOCX, TXT) and returns the file path
  Future<String?> pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'txt', 'docx'], // Include docx extension
    );

    if (result != null && result.files.single.path != null) {
      return result.files.single.path; // Return selected file path
    }
    return null; // No file selected
  }

  /// Extracts text from a DOCX file
  Future<String?> extractTextFromDocx(String filePath) async {
    try {
      // Read the DOCX file as bytes
      File file = File(filePath);
      List<int> bytes = await file.readAsBytes();

      // Unzip the docx file (which is a ZIP archive)
      Archive archive = ZipDecoder().decodeBytes(bytes);

      // Look for the document.xml file inside the DOCX
      for (var file in archive) {
        if (file.name == 'word/document.xml') {
          // Parse the XML content of the document
          String xmlContent = String.fromCharCodes(file.content);
          final document = XmlDocument.parse(xmlContent);

          // Extract the text content from the XML
          String extractedText = '';
          var body = document.findAllElements('w:t'); // w:t holds text nodes in DOCX
          for (var element in body) {
            extractedText += element.text;
          }

          return extractedText;
        }
      }

      return null; // document.xml not found
    } catch (e) {
      print("Error extracting DOCX text: $e");
      return null;
    }
  }

  /// Extracts text from a PDF file using Syncfusion PDF
  Future<String?> extractTextFromPdf(String filePath) async {
    try {
      // Read the PDF file as bytes
      File file = File(filePath);
      List<int> bytes = await file.readAsBytes();

      // Load the PDF document
      final PdfDocument document = PdfDocument(inputBytes: bytes);

      // Get total number of pages
      int pageCount = document.pages.count;

      // Store extracted text from all pages
      String extractedText = '';

      // Loop through each page and extract text
      for (int i = 0; i < pageCount; i++) {
        extractedText += '\n--- Page ${i + 1} ---\n';
        extractedText += PdfTextExtractor(document).extractText(startPageIndex: i, endPageIndex: i);
      }

      // Dispose of the document to free memory
      document.dispose();

      return extractedText;
    } catch (e) {
      print("Error extracting PDF text: $e");
      return null;
    }
  }

  /// Extracts text from a TXT file
  Future<String?> extractTextFromTxt(String filePath) async {
    try {
      return await File(filePath).readAsString();
    } catch (e) {
      print("Error extracting TXT text: $e");
      return null;
    }
  }

  /// Picks a document and automatically extracts its text
  Future<String?> pickAndExtractText() async {
    try {
      String? filePath = await pickDocument();
      if (filePath == null) {
        print("No file selected.");
        return null;
      }

      String? extractedText;
      if (filePath.endsWith('.pdf')) {
        extractedText = await extractTextFromPdf(filePath);
      } else if (filePath.endsWith('.txt')) {
        extractedText = await extractTextFromTxt(filePath);
      } else if (filePath.endsWith('.docx')) {
        extractedText = await extractTextFromDocx(filePath);
      } else {
        print("Unsupported file format!");
        return null;
      }

      if (extractedText != null && extractedText.isNotEmpty) {
        return extractedText;
      } else {
        print("No text extracted.");
        return null;
      }
    } catch (e) {
      print("Error picking and extracting text: $e");
      return null;
    }
  }
}
