class SponsorModel {
  String? id;
  String? name;
  String? logoUrl;

  SponsorModel({
    this.id,
    this.name,
    this.logoUrl,
  });

  factory SponsorModel.fromJson(Map<String, dynamic> json) {
    return SponsorModel(
      id: json['id'],
      name: json['name'],
      logoUrl: json['logoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logoUrl': logoUrl,
    };
  }
}