import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rnp_front/app/core/theme/text.dart';
import 'package:rnp_front/app/core/utils/date.dart';
import 'package:rnp_front/app/data/providers/external/api_provider.dart';
import 'package:rnp_front/app/data/providers/external/src/api_provider_helper.dart';
import 'package:rnp_front/app/global_widgets/atoms/button.dart';
import 'package:rnp_front/app/global_widgets/atoms/safe_image_network.dart';
import 'package:rnp_front/app/global_widgets/molecules/drawer.dart';

import '../../../core/utils/constant.dart';
import '../../../core/values/colors.dart';
import '../../../global_widgets/atoms/curved_navigation_bar.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Pass context to controller for showing profile picture alert
    controller.setContext(context);

    return Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          title: _buildWelcomeHeader(),
          backgroundColor: const Color(0xFFF8DC3D), // Yellow background color
          elevation: 0,
        ),
        drawer: const MoleculeDrawer(
          selectedIndex: 10,
        ),

        // Yellow background color
        body: SafeArea(
          child: Obx(() => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : _buildHomeContent()),
        ),
        bottomNavigationBar: const AtomCurvedNavigationBar(
          selectedIndex: 0,
        ));
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'search'.tr,
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onChanged: (value) {
                  // Handle search
                },
              ),
            ),
          ),
          const SizedBox(
            width: 50,
          ),
          InkWell(
            child: SvgPicture.asset('assets/svg_icons/notification.svg'),
            onTap: () {
              Get.toNamed(Routes.NOTIFICATIONS);
            },
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ColoredBox(
            color: const Color(0xFFF8DC3D),
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildSearchBar(),
                const SizedBox(height: 25),
                _buildSectionHeader('majorActivities'.tr,
                    onViewAll: () => Get.toNamed(Routes.PROGRAM)),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildActivitiesCarousel(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    'sponsors'.tr,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  InkWell(
                    onTap: () => Get.toNamed('/sponsors'),
                    child: Text(
                      'viewAll'.tr,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  )
                ]),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildSponsorsGrid(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Obx(() {
              if (controller.user.value?.user.pathPicture != null &&
                  controller.user.value!.user.pathPicture!.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: ClipOval(
                    child: AtomSafeImageNetwork(
                      path: controller.user.value?.user.pathPicture,
                      headers: ApiProvider().getImageHeaders(),
                      host: hostUploadPhotoProfile,
                      isCircular: true,
                      radius: 25,
                      onTapShowFullScreen: false,
                      imageErrorPath: "images/profile.png",
                    ),
                  ),
                );
              } else {
                return GestureDetector(
                  onTap: () async {
                    await Get.toNamed(Routes.PROFILE);
                    controller.refreshUserData();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: const Icon(
                        Icons.person,
                        color: primaryColor,
                        size: 30,
                      ),
                    ),
                  ),
                );
              }
            }),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'welcome'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Obx(() {
                  return Text(
                    controller.user.value?.user.fullName ?? 'User',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, {required Function() onViewAll}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: onViewAll,
            child: Text(
              'viewAll'.tr,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivitiesCarousel() {
    return CarouselSlider.builder(
      itemCount: controller.programItems.length,
      itemBuilder: (context, index, realIndex) {
        final activity = controller.programItems[index];
        return Container(
          width: Get.width * 0.8,
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(15),
                  ),
                  child: AtomSafeImageNetwork(
                    path: "assets/splash_screen/4.png",

                    width: Get.width * 0.8,
                    height: 200,
                    isCircular: false,

                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.title ?? 'Activity',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 16, color: Colors.amber),
                        const SizedBox(width: 5),
                        Text(
                          UtilsDate.formatMMDD(activity.scheduledDate) ??
                              'No date',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(width: 15),
                        const Icon(Icons.access_time,
                            size: 16, color: Colors.amber),
                        const SizedBox(width: 5),
                        Text(
                          activity.timeStart ?? 'No time',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AtomButton(
                          onPressed: () {
                            Get.toNamed(Routes.PROGRAM_OVERVIEW, parameters: {
                              'taskId': activity.id.toString(),
                            });
                          },
                          isSmall: true,
                          height: 40,
                          label: 'seeMore'.tr,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      options: CarouselOptions(
        height: 370,
        enableInfiniteScroll: true,
        padEnds: false,
        autoPlay: true,
      ),
    );
  }

  Widget _buildSponsorsGrid() {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.sponsors.length,
        itemBuilder: (context, index) {
          final sponsor = controller.sponsors[index];
          return Container(
            width: 80,
            height: 80,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: AtomSafeImageNetwork(
                path: sponsor.logoUrl ?? '',
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label,
      {required bool isSelected}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isSelected ? const Color(0xFFF8DC3D) : Colors.white,
          ),
        ),
        if (label.isNotEmpty)
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
      ],
    );
  }
}
