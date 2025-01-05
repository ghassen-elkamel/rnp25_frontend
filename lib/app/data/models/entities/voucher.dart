import 'dart:convert';
import '../../enums/voucher_type.dart';

List<Voucher> voucherFromJson(dynamic str) =>
    List<Voucher>.from(str["items"].map((x) => Voucher.fromJson(x)));

class Voucher {
  Voucher({
    this.id,
    required this.key,
    this.value,
    this.applicationId,
    this.type,
  });

  final int? id;
  final String key;
  final double? value;
  final int? applicationId;
  final VoucherType? type;

  factory Voucher.fromJson(Map<String, dynamic>? json) {
    VoucherType? type;
    try {
      type = VoucherType.values.byName(json?["type"]);
    } catch (_) {}
    return Voucher(
      id: json?["id"] ?? 0,
      key: json?["key"] ?? "",
      value: double.tryParse(json?["value"].toString() ?? "0"),
      applicationId: json?["applicationId"],
      type: type,
    );
  }

  factory Voucher.fromString(String data) {
    Map<String, dynamic> json = {};
    try {
      json = jsonDecode(data);
    } catch (_) {}
    return Voucher.fromJson(json);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "key": key,
        if (value != null) "value": value,
        if (applicationId != null) "applicationId": applicationId,
        if (type != null) "type": type?.name,
      };
}
