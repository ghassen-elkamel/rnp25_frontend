import 'user.dart';

List<Transaction> transactionFromJson(dynamic str) =>
    List<Transaction>.from(str["items"].map((x) => Transaction.fromJson(x)));

class Transaction {
  Transaction({
    this.id,
    this.idUser,
    this.idBeneficiary,
    required this.amount,
    this.codeVerification,
    this.isVerified,
    this.beneficiary,
    this.user,
    this.countryCode,
    this.phoneNumber,
  });

  final int? id;
  final int? idUser;
  final int? idBeneficiary;
  final double amount;
  final String? codeVerification;
  final bool? isVerified;
  final User? beneficiary;
  final User? user;
  final String? countryCode;
  final String? phoneNumber;

  factory Transaction.fromJson(Map<String, dynamic>? json) {
    User? user;
    if (json?['user'] != null) {
      user = User.fromJson(json?['user']);
    }
    User? beneficiary;
    if (json?['beneficiary'] != null) {
      beneficiary = User.fromJson(json?['beneficiary']);
    }
    return Transaction(
      id: json?["id"],
      idUser: user?.id,
      idBeneficiary: beneficiary?.id,
      amount: double.tryParse(json!["amount"].toString()) ?? 0.0,
      codeVerification: json["codeVerification"],
      countryCode: json["countryCode"],
      phoneNumber: json["phoneNumber"],
      isVerified: json["isVerified"],
      user: json["user"] == null
          ? null
          : User.fromJson(
              json["user"],
            ),
      beneficiary: json["beneficiary"] == null
          ? null
          : User.fromJson(
              json["beneficiary"],
            ),
    );
  }

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "countryCode": countryCode,
        "phoneNumber": phoneNumber,
      };
}
