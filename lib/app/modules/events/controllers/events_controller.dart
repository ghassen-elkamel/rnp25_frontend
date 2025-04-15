import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rnp_front/app/data/models/dto/create_event_dto.dart';
import 'package:rnp_front/app/data/models/entities/event.dart';
import 'package:rnp_front/app/data/services/event_service.dart';

import '../../../core/theme/text.dart';
import '../../../data/models/file_info.dart';

class EventsController extends GetxController {
  EventService eventService = EventService();
  FileInfo? selectedFile;

  TextEditingController imagePath = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
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
        picturePath: selectedFile?.fileName);
    final response = await eventService.createEvent(createEventDto);
    if (response != null) {
      return true;
    }
    return false;
  }

  findCompanyEvents() async {
    final response = await eventService.findCompanyEvents();
    if (response.isNotEmpty) {
      events.value = response;
    }
  }
}
