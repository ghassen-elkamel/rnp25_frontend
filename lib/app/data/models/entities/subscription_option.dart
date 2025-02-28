List<SubscriptionOption> subscriptionOptionsFromJson(dynamic str) =>
    List<SubscriptionOption>.from(str["items"].map((x) => SubscriptionOption.fromJson(x)));


class SubscriptionOption {
  final int id;
  final String subscriptionType;
  final int price;

  SubscriptionOption({
    required this.id,
    required this.subscriptionType,
    required this.price,
  });

  factory SubscriptionOption.fromJson(Map<String, dynamic> json) =>
      SubscriptionOption(
        id: json["id"],
        subscriptionType: json["subscriptionType"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "subscriptionType": subscriptionType,
        "price": price,
      };
}
