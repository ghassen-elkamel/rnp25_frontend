import '../models/entities/voucher.dart';
import '../providers/external/api_provider.dart';

class VoucherService {
  Future<Voucher?> verifyVoucher({required Voucher voucher}) async {
    var response = await ApiProvider().post(
      HttpParamsPostPut(
        endpoint: "/v1/voucher/consume",
        body: voucher.toJson(),
        withLoadingAlert: false,
      ),
    );
    if (response != null) {
      return Voucher.fromJson(response);
    }
    return null;
  }
}
