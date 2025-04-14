import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rnp_front/app/data/providers/storage_provider.dart';

import '../../../data/services/auth_service.dart';

class OnboardingController extends GetxController {
  // Observable for the current page index
  final currentPage = 0.obs;
StorageHelper storageHelper = StorageHelper();
  // PageController to control the page view
  late PageController pageController;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: 0, viewportFraction: 0.85);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  // Method to navigate to the next page
  void nextPage() {
    if (currentPage.value < 2) { // Assuming 3 pages total (0, 1, 2)
      pageController.animateToPage(
        currentPage.value + 1,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      completeOnboarding();
    }
  }



  void skipOnboarding() {
    completeOnboarding();
  }

  void completeOnboarding() async {
    await storageHelper.saveItem(key: 'onboarding_completed', item: true);
    AuthService.goToHomePage();
  }
}