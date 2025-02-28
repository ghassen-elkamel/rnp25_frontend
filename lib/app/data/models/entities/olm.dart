import '../../enums/zone.dart';

List<Olm> olmsFromJson(dynamic str) =>
    List<Olm>.from(str["items"].map((x) => Olm.fromJson(x)));
class Olm {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ZoneType? olmZoneType;
  final String name;

  Olm({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.olmZoneType,
    required this.name,
  });

  factory Olm.fromJson(Map<String, dynamic> json) {
    ZoneType? safeZoneType;
    try {
      safeZoneType = ZoneType.values.byName(json["zone"]);
    } catch (_) {}
    return Olm(
      id: json["id"],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      olmZoneType: safeZoneType,
      name: json["name"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "zone": olmZoneType?.name,
        "name": name,
      };
}
