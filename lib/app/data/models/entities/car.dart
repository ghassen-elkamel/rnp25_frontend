import 'package:eco_trans/app/core/extensions/enum_formatter.dart';
import 'package:eco_trans/app/core/extensions/map/map_extension.dart';
import 'package:eco_trans/app/data/enums/car_type.dart';

import '../../enums/car_status.dart';
import 'car_driver.dart';

List<Car> carsFromJson(dynamic str) =>
    List<Car>.from(str["items"].map((x) => Car.fromJson(x)));

class Car {
  Car({
    this.id,
    this.internalCode,
    required this.brand,
    required this.model,
    required this.registrationNumber,
    required this.carType,
    required this.status,
    this.carDrivers = const [],
  });

  final int? id;
  final String? internalCode;
  final String? brand;
  final String? model;
  final String? registrationNumber;
  final CarType? carType;
  final CarStatus? status;
  final List<CarDriver> carDrivers;

  factory Car.fromJson(
    Map<String, dynamic> json,
  ) {
    return Car(
      id: json["id"],
      internalCode: json["internalCode"],
      brand: json["brand"],
      model: json["model"],
      registrationNumber: json["registrationNumber"],
      carType: CarType.values.tryTransformation(json["carType"]),
      status: CarStatus.values.tryTransformation(json["status"]),
      carDrivers: json.containsKeyNotNull('carDrivers') ? carDriversFromJson(json["carDrivers"]) : [],
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) "id": id,
        if (internalCode != null) "internalCode": internalCode,
        if (model != null) "model": model,
        if (brand != null) "brand": brand,
        if (registrationNumber != null)
          "registrationNumber": registrationNumber,
        if (carType != null) "carType": carType?.name,
        if (status != null) "status": status?.name,
      };

  @override
  String toString() {
    return fullName;
  }

  String get fullName {
    return '$brand $model';
  }

  String fullData() {
    return '$internalCode $registrationNumber $brand $model $carType $status';
  }
}
