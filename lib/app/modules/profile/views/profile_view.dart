import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rnp_front/app/data/providers/external/src/api_provider_helper.dart';

import '../../../core/utils/constant.dart';
import '../../../core/values/colors.dart';
import '../../../data/providers/external/api_provider.dart';
import '../../../global_widgets/atoms/curved_navigation_bar.dart';
import '../../../global_widgets/atoms/safe_image_network.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEDC3C), // Yellow background
      appBar: AppBar(
        backgroundColor: const Color(0xFFFEDC3C),
        elevation: 0,
        title: Text('profile'.tr,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        centerTitle: true,
      ),

      bottomNavigationBar: const AtomCurvedNavigationBar(
        selectedIndex: 2,
      ),
      body: Stack(
        children: [
          // Background
          Column(
            children: [
              // Yellow top section
              Container(
                height: 190,
                color: const Color(0xFFFEDC3C),
              ),
              // White bottom section
              Expanded(
                child: Container(
                  color: Colors.white,
                ),
              ),
            ],
          ),

          // Curved shape between yellow and white
          Positioned(
            top: 120,
            left: 0,
            right: 0,
            child: Container(
              height: 140,
              child: CustomPaint(
                size: Size(MediaQuery.of(context).size.width, 140),
                painter: CurvedPainter(),
              ),
            ),
          ),

          // Content
          Obx(() {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  // Profile picture
                  Align(
                    alignment: Alignment.topCenter,
                    child: buildProfilePhoto(context),
                  ),
                  const SizedBox(height: 10),
                  // Name
                  Text(
                    controller.user.value?.user.fullName ?? 'username',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Title
                  Text(
                    controller.user.value?.positionType != null
                        ? "${controller.user.value?.positionType ?? ''} ${controller.user.value?.positionTitle ?? ''}"
                        : "Member",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Organization
                  Text(
                    controller.user.value?.olm.name ?? 'JCI',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              controller.onEdit.value =
                                  !controller.onEdit.value;
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFEDC3C),
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 0,
                            ),
                            child: Text('editProfile'.tr,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              controller.onLogoutPressed();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade400,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 0,
                            ),
                            child: Text('logout'.tr,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // QR Code
                  Container(
                    width: 350,
                    height: 350,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8DC),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: QrImageView(
                            data: controller.user?.value?.uuid ?? 'default',
                            version: QrVersions.auto,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Scan The QR code',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  )
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget buildProfilePhoto(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: SizedBox(
            width: 120,
            height: 120,
            child: Obx(() {
              if (controller.isLoading.value) {
                return const CircularProgressIndicator();
              } else if (controller.pathPicture.value != "" &&
                  controller.selectedImage.value != null) {
                return ClipOval(
                  child: Image.memory(
                    Uint8List.fromList(controller.selectedImage.value!.bytes),
                    fit: BoxFit.cover,
                  ),
                );
              } else if (controller.user?.value?.user.pathPicture != null &&
                  controller.user?.value?.user.pathPicture != '') {
                return ClipOval(
                  child: AtomSafeImageNetwork(
                    path: controller.user?.value?.user.pathPicture,
                    headers: ApiProvider().getImageHeaders(),
                    host: hostUploadPhotoProfile,
                    isCircular: true,
                  ),
                );
              } else {
                return const Icon(
                  Icons.person,
                  size: 100,
                  color: greyLight,
                );
              }
            }),
          ),
        ),
        if (controller.onEdit.isTrue)
          Positioned(
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: () {
                controller.getImage(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: primaryColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/icons/edit-2.png",
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// Custom painter for the top curved section
class CurvedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    var path = Path()
      ..moveTo(0, 40)
      ..quadraticBezierTo(size.width * 0.5, -40, size.width, 40)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Custom painter for the profile tab
class ProfileTabPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = const Color(0xFFFEDC3C)
      ..style = PaintingStyle.fill;

    var path = Path()
      ..moveTo(0, 30)
      ..quadraticBezierTo(size.width * 0.5, -20, size.width, 30)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
