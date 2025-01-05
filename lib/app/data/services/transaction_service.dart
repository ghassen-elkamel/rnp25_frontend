import '../models/entities/transaction.dart';
import '../providers/external/api_provider.dart';

class TransactionService {
  Future<Transaction?> createTransaction({
    required Transaction transaction,
  }) async {
    var response = await ApiProvider().post(
      HttpParamsPostPut(
        endpoint: "/v1/transaction",
        body: transaction.toJson(),
      ),
    );

    if (response != null) {
      return Transaction.fromJson(response);
    }
    return null;
  }

  Future<Transaction?> verifyTransaction({
    required String code,
    required int transactionCode,
  }) async {
    var response = await ApiProvider().patch(
      HttpParamsPostPut(
        endpoint: "/v1/transaction/check-transaction",
        body: {
          "code": transactionCode,
          "codeVerification": code,
        },
      ),
    );

    if (response != null) {
      return Transaction.fromJson(response);
    }
    return null;
  }
}
