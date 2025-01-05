List<Company> companiesFromJson(dynamic str) =>
    List<Company>.from(str["items"].map((x) => Company.fromJson(x)));

class Company {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int createdBy;
  final String name;
  final bool isMultiCoffer;
  final bool haveDealers;
  final bool withSwiftDetails;
  final bool showCurrentExchangeRate;
  final bool isMultiBalanceClient;
  final bool showInternationalExchangeRate;
  final bool haveCashiers;
  final bool canChargePrincipalSafe;
  final String? imagePath;

  Company({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.name,
    this.imagePath,
    this.isMultiCoffer = true,
    this.haveDealers = true,
    this.withSwiftDetails = true,
    this.showCurrentExchangeRate = true,
    this.isMultiBalanceClient = true,
    this.showInternationalExchangeRate = true,
    this.haveCashiers = true,
    this.canChargePrincipalSafe = true,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        createdBy: json["createdBy"],
        name: json["name"],
        imagePath: json["imagePath"],
        isMultiCoffer: json["isMultiCoffer"],
        haveDealers: json["haveDealers"],
        withSwiftDetails: json["withSwiftDetails"],
    showCurrentExchangeRate: json["showCurrentExchangeRate"],
    isMultiBalanceClient: json["isMultiBalanceClient"],
    showInternationalExchangeRate: json["showInternationalExchangeRate"],
    haveCashiers: json["haveCashiers"],
    canChargePrincipalSafe: json["canChargePrincipalSafe"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "createdBy": createdBy,
        "name": name,
        "isMultiCoffer": isMultiCoffer,
        "haveDealers": haveDealers,
        "withSwiftDetails": withSwiftDetails,
        "showCurrentExchangeRate": showCurrentExchangeRate,
        "isMultiBalanceClient": isMultiBalanceClient,
        "showInternationalExchangeRate": showInternationalExchangeRate,
        "haveCashiers": haveCashiers,
        if (imagePath != null) "imagePath": imagePath,
      };

  @override
  String toString() {
    return name;
  }
}
