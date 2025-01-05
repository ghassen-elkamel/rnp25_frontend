import 'package:eco_trans/app/core/theme/text.dart';
import 'package:eco_trans/app/core/utils/alert.dart';
import 'package:eco_trans/app/core/utils/location.dart';
import 'package:eco_trans/app/data/providers/google_map/google_maps_provider.dart';
import 'package:eco_trans/app/global_widgets/atoms/spinner_progress_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/values/colors.dart';
import '../../../data/providers/google_map/entity/place_details.dart';
import '../../../global_widgets/atoms/floating_action_button.dart';
import '../../../global_widgets/templates/app_scaffold.dart';
import '../controllers/home_controller.dart';
import 'new_trip_bottom_sheet.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      withAppBar: kIsWeb,
      selectedIndex: 1,
      padding: EdgeInsets.zero,
      onSearch: kIsWeb
          ? null
          :(value) async {
        controller.searchResult.clear();
        controller.isLoading.value = true;

        controller.searchResult.value =
            await GoogleMapsProvider().findPlaceFromText(value);
        controller.isLoading.value = false;

        controller.showSearchResult.value = true;
      },
      clearSearch: () {
        controller.showSearchResult.value = false;
      },
      onTapSearch: () {
        controller.showSearchResult.value = true;
      },
      body: Obx(() {
        return Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: controller.initialCameraPosition,
              onMapCreated: (GoogleMapController controllerMap) {
                controller.mapController = controllerMap;
              },
              myLocationButtonEnabled: false,
              markers: {
                if (controller.startPosition.value != null &&
                    controller.startMarker != null)
                  Marker(
                    markerId: const MarkerId("0"),
                    icon: controller.startMarker!,
                    position: controller.startPosition.value!,
                  ),
                if (controller.targetPosition.value != null &&
                    controller.targetMarker != null)
                  Marker(
                      markerId: const MarkerId("1"),
                      icon: controller.targetMarker!,
                      position: controller.targetPosition.value!)
              },
              onTap: kIsWeb
                  ? null
                  : (newPosition) => controller.selectNewPosition(newPosition),
            ),
            Obx(() {
              if (controller.showSearchResult.isFalse) {
                return const SizedBox();
              }
              return Positioned(
                top: 150,
                left: 20,
                right: 20,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white.withOpacity(0.6),
                  ),
                  child: Obx(() {
                    if (controller.searchResult.value.isEmpty) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CustomText.m(
                              "popularLocation".tr,
                              fontWeight: FontWeight.w800,
                              color: black,
                            ),
                          ),
                        ],
                      );
                    }
                    return Column(
                      children: controller.searchResult.value.map(
                        (item) {
                          return InkWell(
                            onTap: () async {
                              controller.isLoading.value = true;

                              PlaceDetails? place = await GoogleMapsProvider()
                                  .findDetailsPlace(item.placeId);
                              controller.isLoading.value = false;

                              if (place == null) {
                                return;
                              }
                              controller.mapController?.moveCamera(
                                CameraUpdate.newLatLngZoom(
                                  place.location,
                                  LocationHelper.defaultZoom,
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomText(
                                item.description,
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    );
                  }),
                ),
              );
            }),
            Obx(() {
              if (controller.startPosition.value == null ||
                  controller.targetPosition.value == null) {
                return const SizedBox();
              }
              return Positioned.directional(
                bottom: 50,
                end: 15,
                textDirection: TextDirection.rtl,
                child: AtomFloatingActionButton.white(
                  onPressed: () {
                    Alert.bottomSheet(
                      NewTripBottomSheet(
                        controller: controller,
                      ),
                    );
                  },
                  icon: Icons.call_split,
                ),
              );
            }),
            Obx(() {
              if (controller.isLoading.isFalse) {
                return const SizedBox();
              }
              return const Positioned(
                child: AtomSpinnerProgressIndicator(),
              );
            }),
          ],
        );
      }),
      floatingActionButtonLocation:kIsWeb ? FloatingActionButtonLocation.endFloat: FloatingActionButtonLocation.startFloat,
      floatingActionButton:AtomFloatingActionButton.white(
        onPressed: () async {
          controller.currentPosition.value = await LocationHelper.getLocation();
          controller.startPosition.value = controller.currentPosition.value;
          if (controller.startPosition.value == null) {
            return;
          }
          controller.mapController?.moveCamera(
            CameraUpdate.newLatLngZoom(
              controller.startPosition.value!,
              LocationHelper.defaultZoom,
            ),
          );
          if (controller.startPosition.value != null &&
              controller.targetPosition.value != null) {
            Alert.bottomSheet(
              NewTripBottomSheet(
                controller: controller,
              ),
            );
          }
        },
        icon: Icons.my_location,
      ),
    );
  }
}
