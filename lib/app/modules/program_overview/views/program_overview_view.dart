import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rnp_front/app/core/theme/text.dart';
import 'package:rnp_front/app/core/utils/constant.dart';
import 'package:rnp_front/app/core/values/colors.dart';
import 'package:rnp_front/app/data/enums/button_type.dart';
import 'package:rnp_front/app/data/providers/external/src/api_provider_helper.dart';
import 'package:rnp_front/app/global_widgets/atoms/button.dart';
import 'package:rnp_front/app/global_widgets/atoms/safe_image_network.dart';
import 'package:rnp_front/app/global_widgets/templates/app_scaffold.dart';

import '../../../data/providers/external/api_provider.dart';
import '../controllers/program_overview_controller.dart';

class ProgramOverviewView extends GetView<ProgramOverviewController> {
  const ProgramOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final goldColor = Color(0xFFE6C22F); // Golden yellow from screenshot

    return Scaffold(
      appBar: AppBar(
        title: Text('details'.tr),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header image section
          Stack(
            children: [
              // Background Image
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                ),
                child: Obx(() => controller.selectedTask.value?.pathPicture != null
                    ? AtomSafeImageNetwork(
                  path: controller.selectedTask.value?.pathPicture ?? '',
                  host: hostUploadTaskPhoto,
                  headers: ApiProvider().getImageHeaders(),
                  width: Get.width * 0.8,
                  height: 200,
                  isCircular: false,
                )
                    : Image.asset(
                  'assets/images/event_placeholder.png',
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
                ),
              ),

              // Time display (9:41)




              // Title overlay - white rounded card with gold text
              Positioned(
                bottom: -20,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Obx(() => Text(
                      controller.selectedTask.value?.title ?? 'Ifriqiya Village',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: goldColor,
                      ),
                    )),
                  ),
                ),
              ),
            ],
          ),

          // Main content area
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date row with circular icon background
                    _buildCircleInfoRow(
                      Icons.calendar_today,
                      Obx(() => Text(
                        controller.selectedTask.value?.scheduledDate != null
                            ? DateFormat('EEEE, dd MMMM yyyy').format(controller.selectedTask.value!.scheduledDate)
                            : 'Samedi, 18 Avril 2025',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      )),
                      goldColor,
                    ),

                    SizedBox(height: 16),

                    // Time row with circular icon background
                    _buildCircleInfoRow(
                      Icons.access_time,
                      Obx(() => Text(
                        controller.selectedTask.value?.timeStart ?? '9:00PM - 1:00PM',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      )),
                      goldColor,
                    ),

                    SizedBox(height: 16),

                    // Location row with circular icon background
                    _buildCircleInfoRow(
                      Icons.location_on,
                      Obx(() => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.selectedTask.value?.location ?? 'Hôtel Riviera Sousse Port El Kantaoui',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'Salle plénière',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      )),
                      goldColor,
                    ),

                    SizedBox(height: 30),

                    // Details section
                    Text(
                      'Details :',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    // Description text
                    Obx(() => Text(
                      controller.selectedTask.value?.description ??
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ),

          // Bottom navigation with back button and heart icon

        ],
      ),
    );
  }

  // New method for the circular icon info rows
  Widget _buildCircleInfoRow(IconData icon, Widget content, Color iconColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Color(0xFFFFF9E6), // Light yellow background
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: content,
          ),
        ),
      ],
    );
  }

  // Keep the original method for compatibility
  Widget _buildInfoRow(IconData icon, Widget content, {String? subtitle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: primaryColor, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              content is Text
                  ? content
                  : DefaultTextStyle(
                style: const TextStyle(fontSize: 16),
                child: content,
              ),
              if (subtitle != null)
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}