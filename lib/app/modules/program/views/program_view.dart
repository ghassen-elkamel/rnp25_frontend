import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rnp_front/app/core/utils/date.dart';
import 'package:rnp_front/app/data/providers/external/src/api_provider_helper.dart';

import '../../../core/utils/constant.dart';
import '../../../core/values/colors.dart';
import '../../../data/providers/external/api_provider.dart';
import '../../../global_widgets/atoms/curved_navigation_bar.dart';
import '../../../global_widgets/atoms/safe_image_network.dart';
import '../controllers/program_controller.dart';

class ProgramView extends GetView<ProgramController> {
  const ProgramView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Pass context to controller for showing profile picture alert
    controller.setContext(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('program'.tr),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      bottomNavigationBar: const AtomCurvedNavigationBar(
        selectedIndex: 1,
      ),
      backgroundColor: white,
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: controller.programItems.length,
              itemBuilder: (context, index) {
                final item = controller.programItems[index];
                RxBool isExpanded = false.obs;

                return Obx(() {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  if (item.subtasks != null &&
                                      item.subtasks!.isNotEmpty) {
                                    isExpanded.value = !isExpanded.value;
                                  }
                                },
                                child: Card(
                                  elevation: 2,
                                  shadowColor: Colors.black12,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Event image
                                            if (item.pathPicture != null)
                                              Container(
                                                width: 80,
                                                height: 60,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: AtomSafeImageNetwork(
                                                    path:
                                                        item.pathPicture ?? '',
                                                    host: hostUploadTaskPhoto,
                                                    headers: ApiProvider()
                                                        .getImageHeaders(),
                                                    width: 80,
                                                    height: 60,
                                                    boxFit: BoxFit.cover,
                                                    isCircular: false,
                                                  ),
                                                ),
                                              ),
                                            if (item.pathPicture != null)
                                              const SizedBox(width: 12),
                                            // Event details
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item.title,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Row(
                                                    children: [
                                                      if (item.location != null)
                                                        Flexible(
                                                          child: Text(
                                                            item.location!,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey[600],
                                                                fontSize: 14),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                          ),
                                                        ),
                                                      if (item.location != null)
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      8),
                                                          width: 1,
                                                          height: 12,
                                                          color:
                                                              Colors.grey[300],
                                                        ),
                                                      Text(
                                                        item.timeStart ??
                                                            UtilsDate
                                                                .formatHHmm(item
                                                                    .scheduledDate),
                                                        style: const TextStyle(
                                                            color: Color(
                                                                0xFFE9B949),
                                                            fontSize: 14),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            if (item.subtasks != null &&
                                                item.subtasks!.isNotEmpty)
                                              IconButton(
                                                  icon: Obx(() => Icon(
                                                        isExpanded.value
                                                            ? Icons
                                                                .keyboard_arrow_up
                                                            : Icons
                                                                .keyboard_arrow_down,
                                                        color: Colors.grey,
                                                      )),
                                                  onPressed: () {
                                                    isExpanded.value =
                                                        !isExpanded.value;
                                                  }),
                                          ],
                                        ),
                                      ),
                                      // Expanded content
                                      if (item.subtasks != null &&
                                          item.subtasks!.isNotEmpty)
                                        AnimatedContainer(
                                          color: Colors.transparent,
                                          duration:
                                              const Duration(milliseconds: 300),
                                          height: isExpanded.value ? null : 0,
                                          child: AnimatedOpacity(
                                            opacity:
                                                isExpanded.value ? 1.0 : 0.0,
                                            duration: const Duration(
                                                milliseconds: 300),
                                            child: isExpanded.value
                                                ? Column(
                                                    children: [
                                                      const Divider(height: 1),
                                                      ...item.subtasks!
                                                          .map(
                                                              (subItem) =>
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                    child:
                                                                        Container(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          vertical:
                                                                              12,
                                                                          horizontal:
                                                                              16),
                                                                      color: const Color(
                                                                          0xFFFEF9DB),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                Text(subItem.title, style: const TextStyle(fontSize: 16)),
                                                                          ),
                                                                          Text(
                                                                            '${subItem.timeStart} - ${subItem.timeEnd}',
                                                                            style:
                                                                                TextStyle(color: Colors.grey[600], fontSize: 14),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )),
                                                    ],
                                                  )
                                                : const SizedBox(),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8E8A6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _getMonth(item.scheduledDate),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    DateFormat('d').format(item.scheduledDate),
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (index < controller.programItems.length - 1)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            width: double.infinity,
                            height: 1,
                            color: Colors.grey[300],
                          ),
                        ),
                    ],
                  );
                });
              },
            )),
    );
  }

  String _getMonth(DateTime date) {
    return DateFormat('MMMM').format(date).substring(0, 3);
  }
}
