import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Pdf extends StatelessWidget {
  const Pdf({super.key,required this.url});
  final url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfPdfViewer.network(
        url,
        canShowPaginationDialog: true,
        pageSpacing: 2.0,
      ),
    );
  }
}
