
import 'package:rnp_front/app/data/providers/external/api_provider.dart';
import '../models/entities/subscription_form.dart';

class UserFormService {
  Future<SubscriptionForm?> verifyUuid(String uuid) async {
    final response = await ApiProvider().get(HttpParamsGetDelete(
        endpoint: '/v1/subscription-form/verify-uuid/$uuid'));
    if (response != null) {
      return SubscriptionForm.fromJson(response);
    }
    return null;
  }

  Future<SubscriptionForm?> getUserUUid() async {
    final response = await ApiProvider().get(HttpParamsGetDelete(
      endpoint: '/v1/subscription-form/user',
    ));
    if (response != null) {
      return SubscriptionForm.fromJson(response);
    }
    return null;
  }
}
