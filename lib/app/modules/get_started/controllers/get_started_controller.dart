import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class GetStartedController extends GetxController {
  void onSignInPressed() {
    // Navigate to sign in screen
    Get.toNamed(Routes.LOGIN);
  }
}