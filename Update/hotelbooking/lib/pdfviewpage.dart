import 'dart:io';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart'; // Ensure the printing package is imported

class PdfPreviewPage extends StatelessWidget {
  final File file;

  const PdfPreviewPage({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking PDF')),
      body: PdfPreview(
        build: (format) => file.readAsBytes(),
      ),
    );
  }
}
