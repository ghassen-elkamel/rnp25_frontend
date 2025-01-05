extension MapExtension on Map? {
  bool containsKeyNotNull(key) {
    if (this == null) {
      return false;
    }
    return this!.containsKey(key) && this![key] != null;
  }
}