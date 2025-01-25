import 'package:rnp_front/app/core/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum PaymentMethod { cash, wallet }

const paymentMethods = [
  PaymentMethod.cash,
  PaymentMethod.wallet,
];

extension InfoPaymentMethod on PaymentMethod {
  Widget icon(bool? isSelected) {
    switch (this) {
      case PaymentMethod.cash:
        return SizedBox(
          height: 50,
          width: 50,
          child: SvgPicture.asset(
            "assets/icons/money/cash.svg",
            colorFilter: ColorFilter.mode(isSelected == true ? primaryColor : grey, BlendMode.srcIn),
          ),
        );
      case PaymentMethod.wallet:
        return  SizedBox(
          height: 50,
          width: 50,
          child: SvgPicture.asset(
            "assets/icons/money/wallet.svg",
            colorFilter: ColorFilter.mode(isSelected == true ? primaryColor : grey, BlendMode.srcIn),
          ),
        );
    }
  }
}
