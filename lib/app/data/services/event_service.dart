import 'package:rnp_front/app/core/extensions/map/map_extension.dart';
import 'package:rnp_front/app/data/models/dto/create_event_dto.dart';
import 'package:rnp_front/app/data/providers/external/api_provider.dart';

import '../models/entities/event.dart';

class EventService {
  createEvent(CreateEventDto event) async {
    final response = await ApiProvider()
        .post(HttpParamsPostPut(endpoint: '/v1/events', body: event.toJson()));
    return response;
  }

 Future<List<Event>> findCompanyEvents() async {
    final response = await ApiProvider()
        .get(HttpParamsGetDelete(endpoint: '/v1/events/company'));
    if (response.containsKeyNotNull('items')) {
      return eventsFromJson(response);
    }
    return <Event>[];
  }
}
