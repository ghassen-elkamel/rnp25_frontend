import 'dart:async';

import 'package:eco_trans/app/core/utils/image.dart';
import 'package:eco_trans/app/data/enums/car_type.dart';
import 'package:eco_trans/app/data/enums/itinerary_steps.dart';
import 'package:eco_trans/app/data/enums/payment_method.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/utils/alert.dart';
import '../../../data/providers/google_map/entity/prediction.dart';
import '../../../data/providers/google_map/google_maps_provider.dart';
import '../views/new_trip_bottom_sheet.dart';

class HomeController extends GetxController {
  GoogleMapController? mapController;
  CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(34.737814,10.752934),
    zoom: 14.4746,
  );

  BytesMapBitmap? startMarker;
  BytesMapBitmap? iterationMarker;
  BytesMapBitmap? targetMarker;

  Rx<LatLng?> currentPosition = Rx(null);
  Rx<LatLng?> startPosition = Rx(null);
  Rx<LatLng?> targetPosition = Rx(null);

  Rx<String> startLocationLabel = Rx("");
  Rx<String> targetLocationLabel = Rx("");
  RxList<Prediction> searchResult = <Prediction>[].obs;
  RxBool showSearchResult = false.obs;
  bool isSelectStartLocation = true;
  RxBool isLoading = false.obs;
  Rx<ItinerarySteps> currentStep = Rx(ItinerarySteps.locations);
  Rx<CarType> selectedCarType = Rx(CarType.taxi);
  Rx<TripEstimation?> tripEstimation = Rx(null);
  Rx<PaymentMethod> selectedPaymentMethod = Rx(PaymentMethod.cash);

  @override
  Future<void> onInit() async {
    isLoading.value = true;
    List result = await Future.wait([
      ImageHelper.getBytesFromAsset("icons/map/ic_iteration.png"),
      ImageHelper.getBytesFromAsset("icons/map/ic_current.png"),
      ImageHelper.getBytesFromAsset("icons/map/ic_pin.png"),
    ]);
    [].add(null);
    iterationMarker = result[0];
    startMarker = result[1];
    targetMarker = result[2];
    isLoading.value = false;

    super.onInit();
  }


  @override
  void onClose() {
    mapController?.dispose();
    super.onClose();
  }

  selectNewPosition(LatLng newPosition) async {
    {
      isLoading.value = true;
      if (isSelectStartLocation) {
        startPosition.value = newPosition;
      } else {
        targetPosition.value = newPosition;
      }
      LocationInfo? place =
          await GoogleMapsProvider().findAddressFromCoordinates(newPosition);
      isLoading.value = false;

      if (place == null) {
        return null;
      }
      String destination = place.description;
      if (isSelectStartLocation) {
        startLocationLabel.value = destination;
        isSelectStartLocation = false;
      } else {
        targetLocationLabel.value = destination;
      }
      if (startPosition.value != null && targetPosition.value != null) {
        showSearchResult.value = false;
        Alert.bottomSheet(
          NewTripBottomSheet(
            controller: this,
          ),
        );
      }
    }
  }

  getTripEstimation() async {
    await Future.delayed(const Duration(seconds: 2));
    tripEstimation.value = TripEstimation(amount: 30 , distance: 15, duration: 9);
  }
}

class TripEstimation {
  final double amount;
  final double distance;
  final double duration;

  TripEstimation({
    required this.amount,
    required this.distance,
    required this.duration,
  });
}

