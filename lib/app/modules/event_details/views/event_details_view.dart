import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/event_details_controller.dart';

class EventDetailsView extends GetView<EventDetailsController> {
  const EventDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('eventDetailsView'.tr),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'EventDetailsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
