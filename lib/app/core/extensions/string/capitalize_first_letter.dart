extension UpperCaseFirstLetterNullable on String? {
  String? get safeCapitalizeFirstLetter {
    String? newString = this;
    if (this != null && this!.isNotEmpty) {
      newString = this!.capitalizeFirstLetter;
    }
    return newString;
  }
}

extension UpperCaseFirstLetter on String {
  String get capitalizeFirstLetter {
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}
