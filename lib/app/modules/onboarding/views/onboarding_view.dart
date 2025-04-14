import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/values/colors.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> imagePaths = [
      'assets/splash_screen/img_1.png',
      'assets/splash_screen/img_2.png',
      'assets/splash_screen/img_3.png',
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const Spacer(),
          // CarouselView in the center
          ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: Get.height * 0.5,
              ),
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: (index) {
                  controller.currentPage.value = index;
                },
                itemCount: imagePaths.length,
                itemBuilder: (context, index) {
                  // Calculate the scale factor based on the current page
                  double scale =
                      controller.currentPage.value == index ? 1.0 : 0.8;

                  return TweenAnimationBuilder(
                    tween: Tween<double>(begin: scale, end: scale),
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOut,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              imagePaths[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              )),

          const SizedBox(height: 20),
          // Page indicator dots
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  imagePaths.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 10,
                    width: controller.currentPage.value == index ? 22 : 10,
                    decoration: BoxDecoration(
                      color: controller.currentPage.value == index
                          ? primaryColor
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              )),
          const Spacer(),
          // Navigation buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: controller.skipOnboarding,
                  child: Text('skipButton'.tr, style: TextStyle(fontSize: 16)),
                ),
                Obx(() => controller.currentPage.value == imagePaths.length - 1
                    ? ElevatedButton(
                        onPressed: controller.completeOnboarding,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'getStarted'.tr,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: controller.nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(15),
                        ),
                        child: const Icon(Icons.arrow_forward,
                            color: Colors.white),
                      )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
