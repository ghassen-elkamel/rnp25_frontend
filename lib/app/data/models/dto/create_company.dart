class CreateCompanyDto {
  final String companyName;

  final int? regionId;
  final String? fullName;

  final String? phoneNumber;
  final String? countryCode;
  final String email;

  CreateCompanyDto({
    required this.companyName,
    required this.regionId,
    required this.fullName,
    required this.phoneNumber,
    required this.countryCode,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
        "companyName": companyName,
        "regionId": regionId,
        "fullName": fullName,
        "phoneNumber": phoneNumber,
        "countryCode": countryCode,
        'email': email
      };
}
