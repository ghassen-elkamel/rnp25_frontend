class ImageLanguage{
  final String path;
  final String code;
  ImageLanguage({required this.code, required this.path});

  @override
  String toString() {
    return code;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageLanguage &&
          runtimeType == other.runtimeType &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;
}