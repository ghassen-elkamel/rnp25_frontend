import 'package:flutter/material.dart';

enum TransactionSrc { card, coupon, transfer, session }

extension TransactionSrcIcon on TransactionSrc? {
  Widget get icon {
    switch (this) {
      case TransactionSrc.card:
        return const Icon(
          Icons.credit_card,
          size: 30,
        );
      case TransactionSrc.transfer:
        return const Icon(
          Icons.sync_alt_outlined,
          size: 30,
        );
      case TransactionSrc.session:
        return const Icon(
          Icons.missed_video_call_outlined,
          size: 30,
        );
      case TransactionSrc.coupon:
        return const Icon(
          Icons.qr_code_2,
          size: 30,
        );
      case null:
        return const Icon(
          Icons.error_outline,
          size: 30,
        );
      default:
        return const SizedBox();
    }
  }
}
