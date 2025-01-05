extension ParseDouble on String?{
  double? get tryDouble => toString().tryDouble;
}
extension StringParseDouble on String{
  double? get tryDouble => double.tryParse(toString().replaceAll(" ", "").replaceAll(",", "."));
}