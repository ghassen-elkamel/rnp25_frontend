import 'package:eco_trans/app/core/utils/transformer.dart';
import 'package:eco_trans/app/data/models/entities/car.dart';
import 'package:eco_trans/app/data/models/entities/user.dart';

List<CarDriver> carDriversFromJson(dynamic str) =>
    List<CarDriver>.from(str.map((x) => CarDriver.fromJson(x)));

class CarDriver {
  CarDriver({
    this.id,
    this.driver,
    this.car,
    required this.isActive,
  });

  final int? id;
  final Driver? driver;
  final Car? car;
  final bool? isActive;

  factory CarDriver.fromJson(
    Map<String, dynamic> json,
  ) {
    return CarDriver(
      id: json["id"],
      car: Transformer(fromJson: Car.fromJson, data: json["car"])
          .tryTransformation(),
      driver: Transformer(fromJson: Driver.fromJson, data: json["driver"])
          .tryTransformation(),
      isActive: json["isActive"],
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) "id": id,
        if (car != null) "car": car?.toJson(),
        if (driver != null) "driver": driver?.toJson(),
        if (isActive != null) "isActive": isActive,
      };
}
