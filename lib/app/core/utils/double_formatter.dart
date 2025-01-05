class DoubleFormatter{
  static String format(double price, {String device = " €"}) {
    return (price.toStringAsFixed(2).contains(".00")
        ? price.toString().replaceAll(RegExp(r'\.0'),"") + device
        : price.toStringAsFixed(2) + device).replaceAll(".", ",");
  }
}