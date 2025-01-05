import 'package:get/get.dart';

enum CarStatus {
  available,
  underMaintenance;

  @override
  String toString() => name.tr;
}

const carStatus = [
  CarStatus.available,
  CarStatus.underMaintenance,
];
