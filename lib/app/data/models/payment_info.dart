class PaymentInfo {
  PaymentInfo({
    required this.clientSecret,
    required this.paymentId,
    required this.customerId,
    required this.ephemeralKey,
  });

  final String? clientSecret;
  final String? paymentId;
  final String? customerId;
  final String? ephemeralKey;

  factory PaymentInfo.fromJson(Map<String, dynamic> json) => PaymentInfo(
    clientSecret: json["client_secret"],
    paymentId: json["payment_id"],
    customerId: json["customer_id"],
    ephemeralKey: json["ephemeral_key"],
  );

  Map<String, dynamic> toJson() => {
    "client_secret": clientSecret,
    "payment_id": paymentId,
    "customer_id": customerId,
    "ephemeral_key": ephemeralKey,
  };
}
