import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../core/values/colors.dart';
import 'dart:developer' as developer;
import 'package:url_launcher/url_launcher.dart';

class PdfPreviewView extends StatefulWidget {
  final String? url;
  final String? assetPath;
  final String title;

  const PdfPreviewView({
    Key? key,
    this.url,
    this.assetPath,
    required this.title,
  })  : assert(url != null || assetPath != null,
            'Either url or assetPath must be provided'),
        super(key: key);

  @override
  State<PdfPreviewView> createState() => _PdfPreviewViewState();
}

class _PdfPreviewViewState extends State<PdfPreviewView> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  bool _isLoading = true;
  String? _errorMessage;

  Future<void> _openInExternalViewer() async {
    if (widget.url != null) {
      final Uri uri = Uri.parse(widget.url!);
      try {
        if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
          throw Exception('Could not launch $uri');
        }
      } catch (e) {
        developer.log('Failed to launch URL: $e', error: e);
        if (mounted) {
          Get.snackbar(
            'Error',
            'Could not open PDF in external viewer',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    } else {
      Get.snackbar(
        'Info',
        'Cannot open asset files in external viewer',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.assetPath != null) {
      developer.log('Loading PDF from asset: ${widget.assetPath}');
    } else if (widget.url != null) {
      developer.log('Loading PDF from URL: ${widget.url}');
    }

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
        actions: [
          if (widget.url != null)
            IconButton(
              icon: const Icon(Icons.open_in_new),
              onPressed: _openInExternalViewer,
              tooltip: 'Open in external viewer',
            ),
        ],
      ),
      body: Stack(
        children: [
          if (widget.assetPath != null)
            SfPdfViewer.asset(
              widget.assetPath!,
              key: _pdfViewerKey,
              canShowScrollHead: true,
              pageSpacing: 4,
              enableDoubleTapZooming: true,
              onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                developer.log('PDF document loaded successfully from asset');
                setState(() {
                  _isLoading = false;
                });
              },
              onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
                developer.log('Asset PDF load failed: ${details.error}',
                    error: details.error);
                setState(() {
                  _isLoading = false;
                  _errorMessage =
                      'Failed to load PDF from asset: ${details.description}';
                });
              },
            )
          else if (widget.url != null)
            SfPdfViewer.network(
              widget.url!,
              key: _pdfViewerKey,
              canShowScrollHead: true,
              pageSpacing: 4,
              enableDoubleTapZooming: true,
              onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                developer.log('PDF document loaded successfully from URL');
                setState(() {
                  _isLoading = false;
                });
              },
              onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
                developer.log('URL PDF load failed: ${details.error}',
                    error: details.error);
                setState(() {
                  _isLoading = false;
                  _errorMessage =
                      'Failed to load PDF from URL: ${details.description}';
                });
              },
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
                    const SizedBox(height: 24),
                    if (widget.url != null)
                      ElevatedButton.icon(
                        onPressed: _openInExternalViewer,
                        icon: const Icon(Icons.open_in_browser),
                        label: const Text('Open in External Viewer'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
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
