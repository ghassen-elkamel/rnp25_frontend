
import 'package:eco_trans/app/core/extensions/map/map_extension.dart';

List<Prediction> predictionsList(Map<String, dynamic>?  json) {
  if(json == null || !(json.containsKeyNotNull('predictions'))){
    return [];
  }
  return json["predictions"].map((e) => Prediction.fromJson(e)).whereType<Prediction>().toList();
}

class Prediction {
  final String description;
  final String placeId;

  Prediction({required this.description, required this.placeId});

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      description: json['description'],
      placeId: json['place_id'],
    );
  }
}


class LocationInfo {
  final String description;
  final String placeId;

  LocationInfo({required this.description, required this.placeId});

  factory LocationInfo.fromJson(Map<String, dynamic> json) {
    return LocationInfo(
      description: json['results'][0]["formatted_address"],
      placeId: json['results'][0]['place_id'],
    );
  }
}