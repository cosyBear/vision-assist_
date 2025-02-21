import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class DocumentHandler {


  static final DocumentHandler _instance = DocumentHandler._internal();

  DocumentHandler._internal();

  // Factory constructor to return the same instance
  factory DocumentHandler() => _instance;

  /// Picks a document (PDF, DOCX, TXT) and returns the file path
  Future<String?> pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'txt'], // Allowed file types
    );

    if (result != null && result.files.single.path != null) {
      return result.files.single.path; // Return selected file path
    }
    return null; // No file selected
  }
  Future<String?> extractTextFromPdf(String filePath) async {
    try {
      // Read the PDF file as bytes
      File file = File(filePath);
      List<int> bytes = await file.readAsBytes();

      // Load the PDF document
      final PdfDocument document = PdfDocument(inputBytes: bytes);

      // Check if the PDF is encrypted and skip it
      if (document.security.userPassword.isNotEmpty) {
        print("This PDF is encrypted and cannot be read.");
        document.dispose();
        return null;
      }

      // Store extracted text from all pages
      StringBuffer extractedText = StringBuffer();

      // Loop through each page and extract text while ignoring images
      for (int i = 0; i < document.pages.count; i++) {
        String pageText = PdfTextExtractor(document).extractText(startPageIndex: i, endPageIndex: i);

        // Skip pages that contain only images or empty pages
        if (pageText.trim().isEmpty || !RegExp(r'[a-zA-Z0-9]').hasMatch(pageText)) {
          continue; // Ignore image-only pages
        }

        // Basic text cleaning
        pageText = pageText.replaceAll(RegExp(r'\s{3,}'), '\n\n'); // Reduce large spacing
        pageText = pageText.replaceAll(RegExp(r'\t+'), ' '); // Convert tabs to spaces

        // Append cleaned text
        extractedText.write("\n--- Page ${i + 1} ---\n");
        extractedText.write(pageText);
      }

      // Dispose of the document to free memory
      document.dispose();

      return extractedText.isNotEmpty ? extractedText.toString().trim() : null;
    } catch (e) {
      print("Error extracting PDF text: $e");
      return null;
    }
  }



  /// Extracts text from a PDF file using Syncfusion PDF
  // Future<String?> extractTextFromPdf(String filePath) async {
  //   try {
  //     // Read the PDF file as bytes
  //     File file = File(filePath);
  //     List<int> bytes = await file.readAsBytes();
  //
  //     // Load the PDF document
  //     final PdfDocument document = PdfDocument(inputBytes: bytes);
  //
  //     // Get total number of pages
  //     int pageCount = document.pages.count;
  //
  //     // Store extracted text from all pages
  //     String extractedText = '';
  //
  //     // Loop through each page and extract text
  //     for (int i = 0; i < pageCount; i++) {
  //       extractedText += '\n--- Page ${i + 1} ---\n';
  //       extractedText += PdfTextExtractor(document).extractText(startPageIndex: i, endPageIndex: i);
  //     }
  //
  //     // Dispose of the document to free memory
  //     document.dispose();
  //
  //     return extractedText;
  //   } catch (e) {
  //     print("Error extracting PDF text: $e");
  //     return null;
  //   }
  // }




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
