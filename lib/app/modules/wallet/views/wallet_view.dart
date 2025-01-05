import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/utils/constant.dart';
import 'package:get/get.dart';
import '../../../core/theme/text.dart';
import '../../../core/utils/alert.dart';
import '../../../core/values/colors.dart';
import '../../../data/enums/button_type.dart';
import '../../../data/enums/recharging_method.dart';
import '../../../global_widgets/atoms/bottom_dialog.dart';
import '../../../global_widgets/atoms/button.dart';
import '../../../global_widgets/atoms/radio_button.dart';
import '../../../global_widgets/atoms/spinner_progress_indicator.dart';
import '../../../global_widgets/atoms/transaction_card.dart';
import '../../../global_widgets/templates/app_scaffold.dart';
import '../../../routes/app_pages.dart';
import '../controllers/wallet_controller.dart';

class WalletView extends GetView<WalletController> {
  const WalletView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'myWallet'.tr,
      selectedIndex: 2,
      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        onRefresh: controller.getTransactionDetails,
        color: primaryColor,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText.xl(
                    "walletBalance".tr,
                    color: primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: Get.width * 0.9,
                    height: 48,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: orange10,
                          border: Border.all(color: orange60)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/svg_icons/wallet.svg",
                                  color: secondColor,
                                ),
                                const SizedBox(width: 6),
                                CustomText.m(
                                  "${'yourBalanceIs'.tr} :",
                                  color: secondColor,
                                )
                              ],
                            ),
                            Obx(() {
                              return Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: CustomText.l(
                                      controller.credit.value?.toStringAsFixed(0),
                                      color: primaryColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const CustomText.m(
                                    secondCurrencyAbbreviation,
                                    color: primaryColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: AlignmentDirectional.center,
                    child: SizedBox(
                      height: 120,
                      child: Center(
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          children: [
                            contentCard(
                              label: 'transferCredit'.tr,
                              onTap: () {
                                Get.toNamed(Routes.TRANSFER_CREDIT);
                              },
                              icon: SvgPicture.asset(
                                'assets/svg_icons/money-send.svg',
                                color: primaryColor,
                                width: 40,
                              ),
                            ),
                            const SizedBox(width: 8),
                            contentCard(
                              label: 'requestCredit'.tr,
                              onTap: () => Alert.showCustomDialog(
                                title: "thisFeatureWillBeAvailableSoon".tr,
                              ),
                              icon: SizedBox(
                                child: SvgPicture.asset(
                                  'assets/svg_icons/money-receive.svg',
                                  color: primaryColor,
                                  width: 40,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            contentCard(
                              label: 'rechargeBalance'.tr,
                              onTap: () {
                                BottomDialog().showBottomDialog(
                                  context,
                                  title: "addCreditUsing".tr,
                                  body: chooseRechargingMethod(context),
                                );
                              },
                              icon: SvgPicture.asset(
                                'assets/svg_icons/strongbox-2.svg',
                                width: 40,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomText.xl(
                      "myTransactions".tr,
                      color: primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Obx(() {
                    if (controller.isLoading.isTrue) {
                      return const AtomSpinnerProgressIndicator();
                    }
                    return Column(
                      children: controller.transactionDetails
                          .map((transactionDetail) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: AtomTransactionCard(
                            transactionDetail: transactionDetail,
                          ),
                        );
                      }).toList(),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget chooseRechargingMethod(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          return AtomRadioButton(
              value: RechargingMethod.card,
              groupValue: controller.rechargingMethod.value,
              onChanged: (value) => controller.rechargingMethod.value =
                  value ?? RechargingMethod.coupon,
              fillColor:
                  controller.rechargingMethod.value == RechargingMethod.card
                      ? primaryColor
                      : indigo60,
              prefix: Row(
                children: [
                  SvgPicture.asset(
                    "assets/svg_icons/card.svg",
                    width: 28,
                    color: controller.rechargingMethod.value ==
                            RechargingMethod.card
                        ? primaryColor
                        : indigo60,
                  ),
                  const SizedBox(width: 6),
                  CustomText.l(
                    "creditCard".tr,
                    fontWeight: controller.rechargingMethod.value ==
                            RechargingMethod.card
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: controller.rechargingMethod.value ==
                            RechargingMethod.card
                        ? primaryColor
                        : indigo60,
                  ),
                ],
              ));
        }),
        const SizedBox(height: 16),
        Obx(() {
          return AtomRadioButton(
            value: RechargingMethod.coupon,
            groupValue: controller.rechargingMethod.value,
            onChanged: (value) => controller.rechargingMethod.value =
                value ?? RechargingMethod.card,
            fillColor:
                controller.rechargingMethod.value == RechargingMethod.coupon
                    ? primaryColor
                    : indigo60,
            prefix: Row(
              children: [
                SvgPicture.asset(
                  "assets/svg_icons/tag.svg",
                  width: 28,
                  color: controller.rechargingMethod.value ==
                          RechargingMethod.coupon
                      ? primaryColor
                      : indigo60,
                ),
                const SizedBox(width: 6),
                CustomText.l(
                  "useCoupon".tr,
                  color: controller.rechargingMethod.value ==
                          RechargingMethod.coupon
                      ? primaryColor
                      : indigo60,
                  fontWeight: controller.rechargingMethod.value ==
                          RechargingMethod.coupon
                      ? FontWeight.w700
                      : FontWeight.w500,
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 32),
        AtomButton(
          label: "next".tr,
          buttonColor: ButtonColor.primary,
          onPressed: () async {
            if (controller.rechargingMethod.value == RechargingMethod.card) {
              //controller.nextChooseRechargingMethod(context);
              Alert.showCustomDialog(
                title: "thisFeatureWillBeAvailableSoon".tr,
              );
            } else {
              await Get.toNamed(Routes.QR_CODE_SCANNER);
              Get.back();
              controller.getTransactionDetails();
            }
          },
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget contentCard({
    required String label,
    required Widget icon,
    required Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 103,
        height: 108,
        child: Column(
          children: [
            SizedBox(
              height: 72,
              width: 72,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: indigo60),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(24),
                  ),
                  color: indigo10,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: icon,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            CustomText.sm(
              label,
              color: primaryColor,
              fontWeight: FontWeight.w700,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}
