extension NotNullAndNotEmpty on String? {
  bool get isFilled => this != null && this!.replaceAll(' ', '').isNotEmpty && this != "null";
}
