import 'package:eco_trans/app/core/utils/language_helper.dart';

extension LanguageNullable on String? {
  String get languageCode {
    if (this?.isEmpty ?? true) {
      return "ar";
    }
    return this!.split("_").first;
  }

  String get language {
    bool isComplex = this?.contains("_") ?? true;
    if(!isComplex){
      return languageCode;
    }

    return "${languageCode}_${this!.split("_").last}";
  }

  String  reverseArabic({String separator = " "}){
    return LanguageHelper.isLTR ? this ?? "" : (this?.split(separator).reversed.join(" ") ?? "");
  }
}
