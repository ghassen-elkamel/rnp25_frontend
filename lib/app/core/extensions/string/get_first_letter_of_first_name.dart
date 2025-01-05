extension GetFirstLetterOfName on String? {
  String get firstLetter {
    if (this != null && this!.isNotEmpty) {
      return "${this?[0].toUpperCase()}. ";
    }
    return "";
  }
}
