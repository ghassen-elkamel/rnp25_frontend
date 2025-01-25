List<Company> companiesFromJson(dynamic str) =>
    List<Company>.from(str["items"].map((x) => Company.fromJson(x)));

class Company {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int createdBy;
  final String name;
  final String? imagePath;

  Company({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.name,
    this.imagePath,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        createdBy: json["createdBy"],
        name: json["name"],
        imagePath: json["imagePath"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "createdBy": createdBy,
        "name": name,
        if (imagePath != null) "imagePath": imagePath,
      };

  @override
  String toString() {
    return name;
  }
}
