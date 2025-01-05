import '../../../data/models/entities/transaction.dart';
import '../../models/entities/user.dart';
import '../../enums/transaction_src.dart';
import '../../enums/transaction_type.dart';

List<TransactionDetail> transactionDetailsFromJson(dynamic str) =>
    List<TransactionDetail>.from(
        str["items"].map((x) => TransactionDetail.fromJson(x)));

class TransactionDetail {
  TransactionDetail({
    this.id,
    this.amount,
    this.timestamp,
    this.type,
    this.src,
    this.user,
    this.transaction,
  });

  final int? id;
  final double? amount;
  final DateTime? timestamp;
  final TransactionType? type;
  final TransactionSrc? src;
  final User? user;
  final Transaction? transaction;

  factory TransactionDetail.fromJson(Map<String, dynamic>? json) {
    TransactionType? transactionType;
    try {
      transactionType = TransactionType.values.byName(json?["type"]);
    } catch (_) {}
    TransactionSrc? transactionSrc;
    try {
      transactionSrc = TransactionSrc.values.byName(json?["src"]);
    } catch (_) {}
    return TransactionDetail(
      id: json?["id"],
      amount: double.tryParse(json!["amount"].toString()) ?? 0.0,
      timestamp: DateTime.tryParse(json["timestamp"] ?? ""),
      type: transactionType,
      src: transactionSrc,
      user: json["user"] == null ? null : User.fromJson(json["user"]),
      transaction: json["transaction"] == null ? null : Transaction.fromJson(json["transaction"]),
    );
  }
}
