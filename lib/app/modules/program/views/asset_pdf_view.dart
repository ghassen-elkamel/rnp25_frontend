import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../core/values/colors.dart';
import 'dart:developer' as developer;

class AssetPdfView extends StatefulWidget {
  final String assetPath;
  final String title;

  const AssetPdfView({
    Key? key,
    required this.assetPath,
    required this.title,
  }) : super(key: key);

  @override
  State<AssetPdfView> createState() => _AssetPdfViewState();
}

class _AssetPdfViewState extends State<AssetPdfView> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  bool _isLoading = true;
  String? _errorMessage;
  String? _tempFilePath;

  @override
  void initState() {
    super.initState();
    _loadPdfFromAsset();
  }

  Future<void> _loadPdfFromAsset() async {
    try {
      developer.log('Loading PDF from asset: ${widget.assetPath}');

      // Read the PDF from assets
      final ByteData data = await rootBundle.load(widget.assetPath);
      final Uint8List bytes = data.buffer.asUint8List();

      // Get temporary directory to store file
      final Directory tempDir = await getTemporaryDirectory();
      final String tempPath = tempDir.path;
      final File tempFile =
          File('$tempPath/${widget.assetPath.split('/').last}');

      // Write to temporary file
      await tempFile.writeAsBytes(bytes);

      if (mounted) {
        setState(() {
          _tempFilePath = tempFile.path;
          _isLoading = false;
        });
      }

      developer
          .log('PDF loaded successfully from asset, temp path: $_tempFilePath');
    } catch (e) {
      developer.log('Asset PDF load failed: $e', error: e);
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load PDF: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Stack(
        children: [
          if (_tempFilePath != null)
            SfPdfViewer.file(
              File(_tempFilePath!),
              key: _pdfViewerKey,
              canShowScrollHead: true,
              pageSpacing: 4,
              enableDoubleTapZooming: true,
            ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          if (_errorMessage != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage!,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
