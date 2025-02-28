import 'package:rnp_front/app/core/extensions/map/map_extension.dart';
import 'package:rnp_front/app/data/providers/external/api_provider.dart';

import '../models/entities/olm.dart';
import '../models/entities/subscription_option.dart';

class OlmsService {
  Future<List<Olm>> getAllOlms() async {
    final response = await ApiProvider().get(HttpParamsGetDelete(
      endpoint: '/v1/olm',
    ));
    if (response.containsKeyNotNull('items')) {
      return olmsFromJson(response);
    }
    return <Olm>[];
  }

  Future<List<SubscriptionOption>> getAllSubscriptionOptions() async {
    final response = await ApiProvider().get(HttpParamsGetDelete(
      endpoint: '/v1/subscription-option',
    ));
    if (response.containsKeyNotNull('items')) {
      return subscriptionOptionsFromJson(response);
    }
    return <SubscriptionOption>[];
  }
}
