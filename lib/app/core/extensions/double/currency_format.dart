import 'package:eco_trans/app/core/utils/constant.dart';
import 'package:intl/intl.dart';

extension CurrencyFormat on double? {
  String get toCurrency {
    if(this == null){
      return  "0.000";
    }

    NumberFormat formatter = NumberFormat.simpleCurrency();
    String formattedAmount = formatter.format(this);
    return "${formattedAmount.replaceAll("\$", "")} $currencyAbbreviation";
  }
}
