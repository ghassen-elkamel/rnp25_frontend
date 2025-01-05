import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../data/models/entities/transaction.dart';
import '../../../data/services/transaction_service.dart';
import '../../../routes/app_pages.dart';

class TransferCreditController extends GetxController {
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController amount = TextEditingController();
  RxBool toVerify = false.obs;
  String countryCode = '216';
  GlobalKey<FormState> formKey = GlobalKey();
  final TransactionService transactionService = TransactionService();


  void createTransaction() async {
    if (formKey.currentState!.validate()) {
      Transaction transaction = Transaction(
        amount: double.tryParse(amount.text)!,
        countryCode: "+$countryCode",
        phoneNumber: phoneNumber.text,
      );
      Transaction? response =
          await transactionService.createTransaction(transaction: transaction);
      if (response != null) {
        Get.toNamed(
          Routes.CHECK_TRANSFER_CODE,
          parameters: {
            "transactionCode": response.id.toString(),
          },
        );
      }
    }
  }
}
