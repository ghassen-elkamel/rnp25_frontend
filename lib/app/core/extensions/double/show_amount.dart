extension NullableDoubleAmount on double?{
  String showAmount({int? decimals}) {
    double amount = this ?? 0;

    return amount.showAmount(decimals: decimals);
  }
}

extension DoubleAmount on double{
  String showAmount({int? decimals}) {

    String formattedAmount = toStringAsFixed(decimals ?? 0);
    if (this >= 1000 || this <=-1000) {
      RegExp regex = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
      formattedAmount =
          formattedAmount.replaceAllMapped(regex, (match) => '${match[1]} ');
    }
    return formattedAmount;
  }
}