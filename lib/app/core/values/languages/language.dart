import 'package:get/get.dart';
import 'package:eco_trans/app/core/extensions/string/language.dart';
import '../../../data/models/item_select.dart';
import 'translations/ar.dart';
import 'translations/en.dart';
import '../../../core/values/languages/base_language.dart';
import '../../../core/values/languages/image_language.dart';

class Language extends Translations {
  final BaseLanguage ar = ArLanguage();
  final BaseLanguage en = EnLanguage();
  static final List<ImageLanguage> list = [
    ImageLanguage(code: "ar", path: "assets/lang/ar.png"),
    ImageLanguage(code: "en", path: "assets/lang/en.png"),
  ];

  static String? getImage(String code){
    return list.firstWhereOrNull((element) => element.code == code)?.path;
  }

  @override
  Map<String, Map<String, String>> get keys => {
    'ar': ar.toJson(),
    'en': en.toJson(),
  };

  static ImageLanguage? getElementByCode(
      String? code,
      ) {
    if (code == null) {
      return null;
    }
    ImageLanguage? item =
    list.firstWhereOrNull((element) => element.code == code);
    return item;
  }

  static ItemSelect? getElementForSelect(String? code) {
    if (code == null) {
      return null;
    }

    ImageLanguage? item = getElementByCode(code.languageCode);
    if (item != null) {
      return ItemSelect(
        label: "",
        value: item,
        pathPicture: item.path,
      );
    }
    return null;
  }
}

