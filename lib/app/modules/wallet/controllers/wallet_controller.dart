import 'package:get/get.dart';
import '../../../core/utils/form_validator.dart';
import '../../../data/enums/recharging_method.dart';
import '../../../data/models/entities/transaction_detail.dart';
import '../../../data/models/entities/user.dart';
import 'package:flutter/material.dart';
import '../../../data/models/payment_info.dart';
import '../../../data/services/payment_service.dart';
import '../../../data/services/transaction_detail_service.dart';
import '../../../data/services/user_service.dart';
import '../../../global_widgets/atoms/bottom_dialog.dart';
import '../../../global_widgets/atoms/button.dart';
import '../../../global_widgets/atoms/text_field.dart';

class WalletController extends GetxController {
  PaymentService paymentService = PaymentService();
  TransactionDetailService transactionDetailService =
      TransactionDetailService();
  final UserService userService = UserService();
  Rx<RechargingMethod> rechargingMethod = RechargingMethod.card.obs;
  TextEditingController rechargingAmount = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController scannedCode = TextEditingController();
  RxList<TransactionDetail> transactionDetails = <TransactionDetail>[].obs;
  User? user;

  RxBool isLoading = true.obs;
  Rx<double?> credit = Rx(0);

  @override
  void onInit() {
    getTransactionDetails();
    super.onInit();
  }

  Future<void> getUser() async {
    user = await userService.findMe();
    if (user != null) {
      credit.value = user?.credit;
    }
  }

  Future<void> getTransactionDetails() async {
    isLoading.value = true;
    // transactionDetails.value =
    //     await transactionDetailService.getTransactionDetail();
    await getUser();
    isLoading.value = false;
  }

  void nextChooseRechargingMethod(BuildContext context) {
    Get.back();
    BottomDialog().showBottomDialog(
      context,
      title: "rechargingWithCreditCard".tr,
      body: chooseAmount(context),
    );
  }

  Widget chooseAmount(BuildContext context) {
    rechargingAmount.text = "";

    return Form(
      key: formKey,
      child: Column(
        children: [
          AtomTextField(
            controller: rechargingAmount,
            autofocus: true,
            label: "rechargingAmount".tr,
            hintText: "100.00",
            suffix: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.monetization_on_outlined),
            ),
            validator: FormValidator().validateDouble,
          ),
          const SizedBox(height: 16),
          AtomButton(
            label: "charging".tr,
            onPressed: () async {
              if (formKey.currentState?.validate() ?? false) {
                PaymentInfo? paymentInfo =
                await paymentService.createPaymentIntent(
                  double.tryParse(rechargingAmount.text) ?? 0,
                );
                if (paymentInfo != null) {
                  //  Payment.initPaymentSheet(context, paymentInfo: paymentInfo);
                }
              }
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
