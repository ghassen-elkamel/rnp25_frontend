import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum CarType {
  taxi,
  family,
  vip;

  @override
  String toString() => name;
}

const carTypes = [
  CarType.taxi,
  CarType.family,
  CarType.vip,
];

extension InfoCarType on CarType {
  Widget get icon {
    switch (this) {
      case CarType.taxi:
        return SvgPicture.asset("assets/icons/car/taxi.svg");
      case CarType.family:
        return SvgPicture.asset("assets/icons/car/family.svg");
      case CarType.vip:
        return SvgPicture.asset("assets/icons/car/vip.svg");
    }
  }
}
