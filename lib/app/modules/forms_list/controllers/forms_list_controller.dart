import 'package:get/get.dart';
import 'package:rnp_front/app/data/models/entities/from.dart';

class FormsListController extends GetxController {
  final Rx<FormEntity?> form = Rx(null);
  final RxInt focusedQuestionIndex = (-1).obs;
  final RxBool isFormPublished = false.obs;

  @override
  void onInit() {
    super.onInit();
  }
}
// form_question_model.dart
