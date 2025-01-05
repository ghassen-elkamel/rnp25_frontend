class CreateCompanyDto {
  final String companyName;
  final String branchName;
  final String? branchPosition;
  final int? branchRegionId;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? countryCode;

  CreateCompanyDto({
    required this.companyName,
    required this.branchName,
    required this.branchPosition,
    required this.branchRegionId,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.countryCode,
  });

  Map<String, dynamic> toJson() => {
        "companyName": companyName,
        "branchName": branchName,
        "branchPosition": branchPosition,
        "branchRegionId": branchRegionId,
        "firstName": firstName,
        "lastName": lastName,
        "phoneNumber": phoneNumber,
        "countryCode": countryCode,
      };
}
