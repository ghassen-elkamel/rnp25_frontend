import '../../../core/utils/transformer.dart';
import 'country.dart';

List<Region> regionFromJson(dynamic str) =>
    List<Region>.from(str["items"].map((x) => Region.fromJson(x)));

class Region {
  Region({
    this.id,
    required this.name,
    required this.nameSecondary,
    this.country,
  });

  final int? id;
  final String name;
  final String nameSecondary;
  final Country? country;

  factory Region.fromJson(Map<String, dynamic> json,) {

    return Region(
      id: json["id"],
      name: json["name"] ,
      nameSecondary: json["nameSecondary"] ,
      country: Transformer(
        fromJson: Country.fromJson,
        data: json["country"],
      ).tryTransformation(),
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) "id": id,
        "name": name,
        "nameSecondary": nameSecondary,
      };

  @override
  String toString() {
    return name;
  }
}
