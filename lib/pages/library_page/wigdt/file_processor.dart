import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../general/document_provider.dart';
import '../../display_page/display_page.dart';
import '../../import_documents/DocumentHandler.dart';
import '../../../general/app_setting_provider.dart';
import '../../upload_page/wigdt/dialogue.dart';

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
      builder: (BuildContext context) => const Dialogue(message: "Loading..."),
    );

    // Allow the dialog to render before starting extraction.
    await Future.delayed(const Duration(milliseconds: 100));

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

    // Use the centralized extraction method.
    String? extractedText = await documentHandler.extractText(documentPath);

    Navigator.pop(context); // Close dialog

    String finalText = extractedText ?? '';

    if (extractedText != null && extractedText.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DisplayPage(
            title: finalText,
            documentName: widget.documentName,
          ),
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
