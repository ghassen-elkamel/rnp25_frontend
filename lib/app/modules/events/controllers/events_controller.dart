import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:rnp_front/app/data/models/dto/create_event_dto.dart';
import 'package:rnp_front/app/data/models/entities/event.dart';
import 'package:rnp_front/app/data/services/event_service.dart';

import '../../../core/theme/text.dart';
import '../../../core/values/colors.dart';
import '../../../data/enums/button_type.dart';
import '../../../data/models/file_info.dart';
import '../../../global_widgets/atoms/button.dart';

class EventsController extends GetxController {
  EventService eventService = EventService();
  FileInfo? selectedFile;

  TextEditingController imagePath = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  Rx<LatLng?> selectedPosition = Rx(null);
  RxList<Event> events = <Event>[].obs;

  @override
  void onInit() {
    findCompanyEvents();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<bool> addItem() async {
    CreateEventDto createEventDto = CreateEventDto(
        title: title.text,
        startDate: startDate,
        endDate: endDate,
        description: description.text,
        picturePath: selectedFile?.fileName,
        location: selectedPosition.value!);
    final response = await eventService.createEvent(createEventDto);
    if (response != null) {
      return true;
    }
    return false;
  }

  selectPosition(context) {
    showDialog(
      context: context,
      builder: (context) {
        return Material(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomText.xxl(
                  "branchPosition".tr,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    FlutterMap(
                      options: MapOptions(
                        initialCenter:
                            selectedPosition.value ?? const LatLng(50.5, 30.51),
                        initialZoom: selectedPosition.value == null ? 6.0 : 15,
                        onTap: (tapPosition, point) {
                          selectedPosition.value = point;
                        },
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          tileProvider: CancellableNetworkTileProvider(),
                        ),
                        Obx(() {
                          return MarkerLayer(
                            markers: [
                              if (selectedPosition.value != null)
                                Marker(
                                  point: selectedPosition.value!,
                                  child: const Icon(
                                    Icons.my_location_rounded,
                                    color: primaryColor,
                                    size: 60,
                                  ),
                                  height: 60,
                                  width: 60,
                                ),
                            ],
                          );
                        }),
                      ],
                    ),
                    Obx(() {
                      if (selectedPosition.value == null) {
                        return const SizedBox();
                      }
                      return Positioned(
                        bottom: 32,
                        right: 32,
                        child: AtomButton(
                          label: 'save'.tr,
                          isSmall: true,
                          onPressed: () {
                            LatLng position = selectedPosition.value!;
                            location.text =
                                "${position.longitude},${position.latitude}";
                            "${position.latitude}, ${position.longitude}";
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    }),
                    Positioned(
                      bottom: 32,
                      left: 32,
                      child: AtomButton(
                        label: 'cancel'.tr,
                        buttonColor: ButtonColor.third,
                        isSmall: true,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  findCompanyEvents() async {
    final response = await eventService.findCompanyEvents();
    if (response.isNotEmpty) {
      events.value = response;
    }
  }
}
