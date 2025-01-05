
import '../../core/extensions/map/map_extension.dart';

import '../models/entities/app_config.dart';

import '../providers/external/api_provider.dart';

class AppService {
  Future<AppConfig?> getVersion() async {
    final response = await ApiProvider().get(HttpParamsGetDelete(
      endpoint: "/v1/appConfig",
      withLoadingAlert: false,
    ));

    if(response.containsKeyNotNull("minVersionAndroid")){
      return AppConfig.fromJson(response!);
    }
    return null;
  }

}