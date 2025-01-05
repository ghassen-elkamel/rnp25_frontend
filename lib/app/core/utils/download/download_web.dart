import 'dart:html' as html;

download(List<int> bodyBytes, String fileName) {
  final blob = html.Blob([bodyBytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.AnchorElement(href: url)
    ..setAttribute("download", fileName)
    ..click();
  html.Url.revokeObjectUrl(url);
}
