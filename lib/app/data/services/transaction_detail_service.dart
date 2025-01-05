import '../models/entities/transaction_detail.dart';
import '../providers/external/api_provider.dart';

class TransactionDetailService {
  Future<List<TransactionDetail>> getTransactionDetail() async {
    var response = await ApiProvider().get(
      HttpParamsGetDelete(
        endpoint: "/v1/transaction-detail",
        withLoadingAlert: false,
      ),
    );
    if (response != null) {
      return transactionDetailsFromJson(response);
    }
    return [];
  }
}
