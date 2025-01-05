import 'package:flutter/material.dart';

import '../../core/values/colors.dart';

enum TransactionType { debit, credit }

extension TransactionTypeIcon on TransactionType? {
  Widget get icon {
    switch (this) {
      case TransactionType.debit:
        return const Icon(
          Icons.arrow_upward,
          color: Colors.white,
          size: 16,
        );

      case TransactionType.credit:
        return const Icon(
          Icons.arrow_downward,
          color: Colors.white,
          size: 16,
        );
      default:
        return const SizedBox();
    }
  }
  Color get color {
    switch (this) {
      case TransactionType.debit:
        return greenLight;

      case TransactionType.credit:
        return red;
      default:
        return primaryColor;
    }
  }
}
