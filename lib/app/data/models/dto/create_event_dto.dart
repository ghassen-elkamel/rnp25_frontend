import 'package:latlong2/latlong.dart';
import 'package:rnp_front/app/core/extensions/latlng/latlng_extension.dart';

class CreateEventDto {
  final String title;
  final String description;
  final LatLng? location;
  final DateTime startDate;
  final DateTime endDate;
  final String? picturePath;

  CreateEventDto(
      {required this.title,
      required this.description,
      required this.location,
      required this.startDate,
      required this.endDate,
      this.picturePath});

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        if (location != null) "location": location.toStringKey,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        if (picturePath != null) "picturePath": picturePath
      };
}
