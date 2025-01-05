class ItemSelect<T> {
  final String label;
  final String? pathPicture;
  final T value;

  const ItemSelect({
    required this.label,
    this.pathPicture,
    required this.value,
  });
}
