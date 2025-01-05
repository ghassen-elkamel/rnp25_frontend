
import '../models/payment_info.dart';
import '../providers/external/api_provider.dart';

class PaymentService {
  Future<PaymentInfo?> createPaymentIntent(double amount) async {
    var response = await ApiProvider().post(
      HttpParamsPostPut(
        endpoint: "/v1/stripe-payment",
        body: {
          "amount": amount,
        },
      ),
    );
    if (response != null) {
      return PaymentInfo.fromJson(response);
    }
    return null;
  }

}
