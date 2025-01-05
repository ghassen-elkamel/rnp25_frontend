import 'download_mobile.dart' if (dart.library.html) 'download_web.dart'
    as platform;

class DocumentHelper {
  static download({required List<int> bodyBytes, required String fileName}) {
    platform.download(bodyBytes, fileName);
  }
}
/**
 * Config Android:
 *
 * */