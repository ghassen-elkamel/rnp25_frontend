import 'package:latlong2/latlong.dart';

extension LatLngToJson on LatLng? {
  String? get toStringKey {
    if (this == null) {
      return null;
    }
    return '${this!.latitude},${this!.longitude}';
  }
}