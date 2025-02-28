class CreateSubscriptionFormDto {
  final CreateUserDto createUserDto;
  final String positionType;
  final String positionTitle;
  final int subscriptionTypeId;
  final int olmId;

  CreateSubscriptionFormDto({
    required this.createUserDto,
    required this.positionType,
    required this.positionTitle,
    required this.subscriptionTypeId,
    required this.olmId,
  });

  factory CreateSubscriptionFormDto.fromJson(Map<String, dynamic> json) {
    return CreateSubscriptionFormDto(
      createUserDto: CreateUserDto.fromJson(json['createUserDto']),
      positionType: json['positionType'],
      positionTitle: json['positionTitle'],
      subscriptionTypeId: json['subscriptionTypeId'],
      olmId: json['olmId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createUserDto': createUserDto.toJson(),
      'positionType': positionType,
      'positionTitle': positionTitle,
      'subscriptionTypeId': subscriptionTypeId,
      'olmId': olmId,
    };
  }
}

class CreateUserDto {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String countryCode;
  final String? password;

  CreateUserDto({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.countryCode,
    this.password,
  });

  factory CreateUserDto.fromJson(Map<String, dynamic> json) {
    return CreateUserDto(
      fullName: json['fullName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      countryCode: json['countryCode'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'countryCode': countryCode,
      'password': password,
    };
  }
}
