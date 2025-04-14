import 'package:get/get.dart';
import 'package:rnp_front/app/data/models/entities/task.dart';
import 'package:rnp_front/app/data/services/program_service.dart';

class ProgramOverviewController extends GetxController {
  final ProgramService programService = ProgramService();
  final Rx<Task?> selectedTask = Rx<Task?>(null);
  final RxBool isFavorite = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Get task ID from parameters if available
    if (Get.parameters['taskId'] != null) {
      loadTaskDetails(Get.parameters['taskId']!);
    }
  }

  Future<void> loadTaskDetails(String taskId) async {
    try {
      final task = await programService.finOne(taskId);
      selectedTask.value = task;
    } catch (e) {
      print('Error loading task details: $e');
    }
  }

  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
    // Implement favorite functionality here
  }
}
