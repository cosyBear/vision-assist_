import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../general/document_provider.dart';
import '../../display_page/display_page.dart';
import '../../import_documents/DocumentHandler.dart';
import '../../../general/app_setting_provider.dart';

class FileProcessorWidget extends StatefulWidget {
  final String documentName;

  const FileProcessorWidget({super.key, required this.documentName});

  @override
  _FileProcessorWidgetState createState() => _FileProcessorWidgetState();
}

class _FileProcessorWidgetState extends State<FileProcessorWidget> {
  Future<void> _handleDocument(BuildContext context) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(203, 105, 156, 1)),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Extracting text, please wait...",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );

    final documentProvider = Provider.of<DocumentProvider>(context, listen: false);
    final documentHandler = DocumentHandler();

    String? documentPath = documentProvider.getDocumentPath(widget.documentName);

    if (documentPath == null) {
      Navigator.pop(context); // Close dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Document not found: ${widget.documentName}")),
      );
      return;
    }

    String? extractedText;
    if (documentPath.endsWith('.pdf')) {
      extractedText = await documentHandler.extractTextFromPdf(documentPath);
    } else if (documentPath.endsWith('.txt')) {
      extractedText = await documentHandler.extractTextFromTxt(documentPath);
    } else if (documentPath.endsWith('.docx')) {
      extractedText = await documentHandler.extractTextFromDocx(documentPath);
    } else if (documentPath.endsWith('.md')) {
      extractedText = await documentHandler.extractTextFromMd(documentPath);
    } else if (documentPath.endsWith('.epub')) {
      extractedText = await documentHandler.extractTextFromEpub(documentPath);
    }

    Navigator.pop(context); // Close dialog

    String finalText = extractedText ?? '';

    if (extractedText != null && extractedText.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DisplayPage(title: finalText),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No text extracted from the document.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingProvider>(context);
    Color textColor = settings.textColor;
    double fontSize = settings.fontSize;

    return GestureDetector(
      onTap: () => _handleDocument(context),
      child: ListTile(
        title: Text(
          widget.documentName,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
