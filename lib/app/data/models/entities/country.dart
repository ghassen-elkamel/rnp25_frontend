List<Country> countryFromJson(dynamic str) =>
    List<Country>.from(str["items"].map((x) => Country.fromJson(x)));

class Country {
  Country({
    this.id,
    required this.name,
    required this.countryCode,
    required this.phoneCountryCode,
  });

  final int? id;
  final String name;
  final String countryCode;
  final String phoneCountryCode;

  factory Country.fromJson(Map<String, dynamic> json,) {
    return Country(
      id: json["id"],
      name: json["name"] ,
      countryCode: json["countryCode"] ,
      phoneCountryCode: json["phoneCountryCode"] ,
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) "id": id,
    "name": name,
    "countryCode": countryCode,
    "phoneCountryCode": phoneCountryCode,
  };

  @override
  String toString() {
    return name;
  }
}
