import 'dart:io';

void main() {
  // Step 1: Get the base language word
  print('Enter the base language word:');
  var baseWord = stdin.readLineSync()?.trim();

  if (baseWord == null || baseWord.isEmpty) {
    print('Base word cannot be empty. Exiting.');
    return;
  }

  // Step 2: Get the JSON key (camelCase, e.g., myNewKey)
  print('Enter the JSON key (camelCase, e.g., myNewKey):');
  var jsonKey = stdin.readLineSync()?.trim();

  if (jsonKey == null || jsonKey.isEmpty) {
    print('JSON key cannot be empty. Exiting.');
    return;
  }

  // Step 3: Initialize translations map
  final translations = <String, Map<String, String>>{};

  // Step 4: Read existing translations for each language
  for (var languageCode in Language.list.map((lang) => lang.code)) {
    print('Enter translation for $languageCode (leave empty for todo):');
    var translation = stdin.readLineSync()?.trim();

    translations[languageCode] = {baseWord: translation ?? ''};
  }

  // Step 5: Update existing language files
  for (var language in Language.list) {
    var languageFile = File(
        'lib/app/core/values/languages/translations/${language.code}.dart');
    var languageContent = languageFile.readAsStringSync();

    // Remove the end of file
    languageContent = languageContent.replaceAll('}', '');

    // Add @override getter for the base word
    languageContent +=
    '\n\n  @override\n  String get $baseWord => "${translations[language.code]![baseWord]}"; \n}';

    languageFile.writeAsStringSync(languageContent);
  }

  // Step 6: Update BaseLanguage file
  var baseLanguageFile =
  File('lib/app/core/values/languages/base_language.dart');
  var baseLanguageContent = baseLanguageFile.readAsStringSync();

  // Add String get baseWord; at the beginning of the BaseLanguage abstract class
  baseLanguageContent = baseLanguageContent.replaceFirst(
      'abstract class BaseLanguage {',
      'abstract class BaseLanguage {\n\n  String get $baseWord;');

  // Remove existing translations for the base word
  baseLanguageContent = baseLanguageContent.replaceAll(
      '  \'$baseWord\': ${translations[Language.list.first.code]![baseWord] ?? 'TODO'},',
      '');

  // Step 7: Add new translation key declarations in toJson method
  var toJsonMethodIndex =
      baseLanguageContent.indexOf('Map<String, String> toJson() {') + 1;
  var toJsonMethodEndIndex = baseLanguageContent.lastIndexOf(',');

  // Build the translation entries in the desired format
  var baseLanguageMap =
  translations[Language.list.first.code]!.entries.map((entry) {
    return '"$jsonKey": ${entry.key}';
  }).toList();

  // Replace the existing translation entries with the new ones
  baseLanguageContent = baseLanguageContent.replaceRange(toJsonMethodEndIndex,
      toJsonMethodEndIndex, ',\n${baseLanguageMap.join('\n')}');

  baseLanguageFile.writeAsStringSync(baseLanguageContent);

  // Step 8: Print success message
  print('Translations updated successfully!');
}

// Class representing supported languages
class Language {
  static final List<ImageLanguage> list = [
    ImageLanguage(code: "en", path: "assets/lang/en.png"),
    ImageLanguage(code: "ar", path: "assets/lang/ar.png"),
  ];
}

// Class representing an image language with code and path
class ImageLanguage {
  final String code;
  final String path;

  ImageLanguage({required this.code, required this.path});
}

// Extension method to convert base word and keys to camel case
extension CamelCaseConversion on String {
  String toCamelCase([String? languageCode]) {
    var words = split('-');
    var camelCaseWord = words.first.toLowerCase() +
        words
            .sublist(1)
            .map((word) => word[0].toUpperCase() + word.substring(1))
            .join('');
    return languageCode != null
        ? camelCaseWord + languageCode.toUpperCase()
        : camelCaseWord;
  }
}
