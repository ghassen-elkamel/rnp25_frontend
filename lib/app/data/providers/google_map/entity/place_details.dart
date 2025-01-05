import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceDetails{
  final LatLng location;
  final String name;

  PlaceDetails({required this.location, required this.name});

  factory PlaceDetails.fromJson(Map<String, dynamic> json) {
    return PlaceDetails(
      name: json['result']['name'],
      location: LatLng(json['result']["geometry"]['location']["lat"], json['result']["geometry"]['location']['lng']),
    );
  }
}