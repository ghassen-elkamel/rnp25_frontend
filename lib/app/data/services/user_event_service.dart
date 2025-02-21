import 'package:rnp_front/app/data/models/entities/user-event.dart';
import 'package:rnp_front/app/data/providers/external/api_provider.dart';

class UserEventService {
  Future<UserEvent?> verifyUuid(String uuid) async {
    final response = await ApiProvider().get(HttpParamsGetDelete(
        endpoint: '/v1/user-event/verify-uuid/$uuid'));
    if (response != null) {
      return UserEvent.fromJson(response);
    }
    return null;
  }

  Future<UserEvent?> getUserUUid(eventID) async {
    final response = await ApiProvider().get(HttpParamsGetDelete(
      endpoint: '/v1/user-event/event/$eventID',
    ));
    if (response != null) {
      return UserEvent.fromJson(response);
    }
    return null;
  }
}
