import 'dart:developer';

import 'package:eco_trans/app/core/extensions/string/language.dart';
import 'package:eco_trans/app/core/utils/language_helper.dart';
import 'package:eco_trans/app/data/providers/external/api_provider.dart';
import 'package:eco_trans/app/data/providers/google_map/entity/place_details.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'entity/prediction.dart';

class GoogleMapsProvider {
  static String apiKey= "AIzaSyDypJRZW1wsdqxcSqG043txQi1KjuiwUBI";

  Future<List<Prediction>> findPlaceFromText(String text) async {
    var result = await ApiProvider().get(
      HttpParamsGetDelete(
        protocol: "https",
        endpoint: "maps/api/place/autocomplete/json",
        externalHost: "maps.googleapis.com",
        externalPort: null,
        isUnderAPI: false,
        withLoadingAlert: false,
        queryParam: {
          "input": text,
          "inputtype": "textquery",
          "key": apiKey,
        },headers: {
      'Access-Control-Allow-Origin': '*'
      }
      ),
    );

    return predictionsList(result);
  }

  Future<PlaceDetails?> findDetailsPlace(String placeId) async {
    Map<String, dynamic>? result = await ApiProvider().get(
      HttpParamsGetDelete(
          protocol: "https",
          endpoint: "maps/api/place/details/json",
          externalHost: "maps.googleapis.com",
          externalPort: null,
          isUnderAPI: false,
          withLoadingAlert: false,
          queryParam: {
            "place_id": placeId,
            "key": apiKey,
          }
      ),
    );
    try {
      return PlaceDetails.fromJson(result!);
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
  Future<LocationInfo?> findAddressFromCoordinates(LatLng location) async {
    Map<String, dynamic>? result = await ApiProvider().get(
      HttpParamsGetDelete(
          protocol: "https",
          endpoint: "maps/api/geocode/json",
          externalHost: "maps.googleapis.com",
          externalPort: null,
          isUnderAPI: false,
          withLoadingAlert: false,
          queryParam: {
            "latlng": "${location.latitude},${location.longitude}",
            "key": apiKey,
            "language": LanguageHelper.language.languageCode,
          },
          headers: {
            'Access-Control-Allow-Origin': '*'
          }
      ),
    );
    try {
      return LocationInfo.fromJson(result!);
    } catch (e) {
      log("e.toString()");
      log(e.toString());
    }
    return null;
  }
}


