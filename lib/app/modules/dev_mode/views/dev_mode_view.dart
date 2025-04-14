import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rnp_front/app/core/values/colors.dart';
import 'package:rnp_front/app/routes/app_pages.dart';
import '../../../core/theme/text.dart';
import '../controllers/dev_mode_controller.dart';
import 'dart:ui';

class DevModeView extends GetView<DevModeController> {
  const DevModeView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    primaryColor.withOpacity(0.05),
                    secondColor.withOpacity(0.07),
                  ],
                ),
              ),
            ),
          ),

          // Decorative circles
          Positioned(
            top: -size.width * 0.4,
            left: -size.width * 0.2,
            child: Container(
              width: size.width * 0.8,
              height: size.width * 0.8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withOpacity(0.06),
              ),
            ),
          ),

          Positioned(
            bottom: -size.width * 0.3,
            right: -size.width * 0.2,
            child: Container(
              width: size.width * 0.7,
              height: size.width * 0.7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: secondColor.withOpacity(0.08),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Logo section with glass effect
                Container(
                  height: size.height * 0.3,
                  margin: const EdgeInsets.all(24),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.5),
                              Colors.white.withOpacity(0.3),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.5),
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Image.asset(
                            "assets/images/icon.jpg",
                            width: size.width * 0.6,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Animated status indicator
                        AnimatedContainer(
                          duration: const Duration(seconds: 1),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.15),
                                blurRadius: 20,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildPulsingDot(),
                              const SizedBox(width: 12),
                              CustomText.xl(
                                "inDev".tr,
                                fontWeight: FontWeight.w600,
                                color: primaryColor,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Gear animation with spotlight effect
                        Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.white,
                                Colors.white.withOpacity(0.0),
                              ],
                              stops: [0.7, 1.0],
                            ),
                          ),
                          child: Center(
                            child: Image.asset(
                              "assets/images/gear.gif",
                              height: 130,
                            ),
                          ),
                        ),


                        GestureDetector(
                          onTap: () => Get.offAllNamed(Routes.SPLASH_SCREEN),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [primaryColor, secondColor],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(26),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.refresh_rounded,
                                      color: primaryColor),
                                  const SizedBox(width: 8),
                                  CustomText.l(
                                    "Refresh".tr,
                                    fontWeight: FontWeight.w600,
                                    color: primaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Animated pulsing dot
  Widget _buildPulsingDot() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.5, end: 1.0),
      duration: const Duration(seconds: 1),
      builder: (context, value, child) {
        return Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: primaryColor.withOpacity(value),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.3 * value),
                blurRadius: 10 * value,
                spreadRadius: 2 * value,
              ),
            ],
          ),
        );
      },
      onEnd: () {},
    );
  }

  // Info card with subtle animation
  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required double offset,
  }) {
    return Transform.translate(
      offset: Offset(0, offset),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: primaryColor, size: 28),
            const SizedBox(height: 8),
            CustomText.m(
              title,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            CustomText.sm(
              subtitle,
              color: greyLight,
            ),
          ],
        ),
      ),
    );
  }
}
