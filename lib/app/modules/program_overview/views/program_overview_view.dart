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
    final goldColor = const Color(0xFFE6C22F);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Obx(() {
        if (controller.selectedTask.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Custom App Bar with Full Width Image
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              backgroundColor: primaryColor,
              leading: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: GestureDetector(
                    onTap: () => controller.toggleFavorite(),
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          controller.isFavorite.value
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Full Width Image without radius
                    controller.selectedTask.value?.pathPicture != null
                        ? AtomSafeImageNetwork(
                            path: controller.selectedTask.value?.pathPicture ??
                                '',
                            host: hostUploadTaskPhoto,
                            headers: ApiProvider().getImageHeaders(),
                            boxFit: BoxFit.cover,
                            isCircular: false,
                            radius: 0,
                          )
                        : Image.asset(
                            'assets/images/event_placeholder.png',
                            fit: BoxFit.cover,
                          ),

                    // Gradient overlay for better text visibility
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.5),
                          ],
                          stops: const [0.6, 1.0],
                        ),
                      ),
                    ),

                    // Event Title and Time
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Event Time Badge
                          if (controller.selectedTask.value?.timeStart != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: goldColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                controller.selectedTask.value?.timeStart ?? '',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          const SizedBox(height: 10),

                          // Event Title
                          Text(
                            controller.selectedTask.value?.title ?? '',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 10.0,
                                  color: Colors.black,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Content
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Info Cards
                  Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Date row
                        _buildInfoRow(
                          icon: Icons.calendar_today,
                          iconColor: goldColor,
                          title: 'Date',
                          content: controller
                                      .selectedTask.value?.scheduledDate !=
                                  null
                              ? DateFormat('EEEE, dd MMMM yyyy').format(
                                  controller.selectedTask.value!.scheduledDate)
                              : '',
                        ),

                        const Divider(height: 30),

                        // Time row
                        _buildInfoRow(
                          icon: Icons.access_time,
                          iconColor: goldColor,
                          title: 'Time',
                          content:
                              controller.selectedTask.value?.timeStart ?? '',
                        ),

                        if (controller.selectedTask.value?.location !=
                            null) ...[
                          const Divider(height: 30),

                          // Location row
                          _buildInfoRow(
                            icon: Icons.location_on,
                            iconColor: goldColor,
                            title: 'Location',
                            content:
                                controller.selectedTask.value?.location ?? '',
                            subtitle: 'Salle plénière',
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Details section
                  if (controller.selectedTask.value?.description != null &&
                      controller.selectedTask.value!.description!.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header with gold accent
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: goldColor.withOpacity(0.1),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline, color: goldColor),
                                const SizedBox(width: 10),
                                Text(
                                  'Details'.tr,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: goldColor,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Description content
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              controller.selectedTask.value?.description ?? '',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[800],
                                height: 1.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Schedule section
                  if (controller.selectedTask.value?.subtasks != null &&
                      controller.selectedTask.value!.subtasks!.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header with gold accent
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: goldColor.withOpacity(0.1),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.event_note, color: goldColor),
                                const SizedBox(width: 10),
                                Text(
                                  'Schedule'.tr,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: goldColor,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Timeline for subtasks
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                for (var i = 0;
                                    i <
                                        controller.selectedTask.value!.subtasks!
                                            .length;
                                    i++)
                                  _buildTimelineItem(
                                    subtask: controller
                                        .selectedTask.value!.subtasks![i],
                                    isLast: i ==
                                        controller.selectedTask.value!.subtasks!
                                                .length -
                                            1,
                                    goldColor: goldColor,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  // New info row widget
  Widget _buildInfoRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
    String? subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 22,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.tr,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // Timeline item for subtasks
  Widget _buildTimelineItem({
    required dynamic subtask,
    required bool isLast,
    required Color goldColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline dot and line
        SizedBox(
          width: 24,
          child: Column(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: goldColor,
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 60,
                  color: goldColor.withOpacity(0.3),
                ),
            ],
          ),
        ),
        const SizedBox(width: 15),

        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (subtask.timeStart != null)
                Text(
                  '${subtask.timeStart}${subtask.timeEnd != null ? ' - ${subtask.timeEnd}' : ''}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: goldColor,
                  ),
                ),
              const SizedBox(height: 5),
              Text(
                subtask.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (subtask.durationMinutes != null)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    '${subtask.durationMinutes} ${'minutes'.tr}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              SizedBox(height: isLast ? 0 : 20),
            ],
          ),
        ),
      ],
    );
  }
}
