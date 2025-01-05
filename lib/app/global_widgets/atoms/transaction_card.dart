import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../core/utils/constant.dart';
import '../../core/theme/text.dart';
import '../../core/utils/date.dart';
import '../../core/values/colors.dart';
import '../../data/enums/transaction_src.dart';
import '../../data/enums/transaction_type.dart';
import '../../data/models/entities/transaction_detail.dart';

class AtomTransactionCard extends StatelessWidget {
  final TransactionDetail transactionDetail;

  const AtomTransactionCard({super.key, required this.transactionDetail});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: secondColor),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(
                    transactionDetail.type == TransactionType.credit
                        ? "assets/svg_icons/money-send.svg"
                        : "assets/svg_icons/money-receive.svg",
                    color: secondColor,
                    width: 32,
                  ),
                  CustomText.sm(
                    UtilsDate.formatDDMMYYYYHHmm(transactionDetail.timestamp),
                    textAlign: TextAlign.left,
                    color: indigo40,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: CustomText.l(
                  transactionDetail.type == TransactionType.debit
                      ? "receivedDebit".tr
                      : "transferCredit".tr,
                  fontWeight: FontWeight.w400,
                  color: secondColor,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText.m(
                      'transferredBalance'.tr,
                      color: indigo60,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: CustomText.l(
                            transactionDetail.amount?.toString(),
                            color: primaryColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Padding(
                          padding:  EdgeInsets.only(top: 4.0),
                          child:  CustomText.sm(
                            currencyAbbreviation,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getBody() {
    switch (transactionDetail.src) {
      case TransactionSrc.transfer:
        if (transactionDetail.type == TransactionType.credit) {
          return CustomText.m(
            "${"sent".tr} ${"to".tr} ${transactionDetail.transaction?.beneficiary?.fullName}",
          );
        }
        if (transactionDetail.type == TransactionType.debit) {
          return CustomText.m(
            "${"received".tr} ${"from".tr.toLowerCase()} ${transactionDetail.transaction?.user?.fullName}",
          );
        }
        break;
      case TransactionSrc.card:
      case TransactionSrc.coupon:
        return CustomText.m("charging".tr);
      case TransactionSrc.session:
        return CustomText.m("session".tr);
      default:
    }
    return const SizedBox();
  }
}
