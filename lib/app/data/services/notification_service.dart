import '../models/response/meta_data.dart';
import '../models/response/paginated.dart';
import '../models/entities/notification.dart';
import '../providers/external/api_provider.dart';

class NotificationService {
  Future<Paginated<Notifications>> getNotifications(PageMetaData page) async {
    var response = await ApiProvider().get(
      HttpParamsGetDelete(
        endpoint: "/v1/notification",
        withLoadingAlert: false,
        queryParam: page.toJson(),
      ),
    );

    return paginatedFromJson<Notifications>(response, Notifications.fromJson);
  }

  Future<Notifications?> viewNotification({
    int? idNotification,
  }) async {
    var response = await ApiProvider().patch(
      HttpParamsPostPut(
        endpoint: "/v1/notification/$idNotification",
        body: {},
        withLoadingAlert: false,
      ),
    );
    if (response != null) {
      return Notifications.fromJson(response);
    }
    return null;
  }
}
