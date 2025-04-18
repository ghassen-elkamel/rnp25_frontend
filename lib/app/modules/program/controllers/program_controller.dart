import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rnp_front/app/data/models/entities/subscription_form.dart';
import 'package:rnp_front/app/data/models/entities/task.dart';
import 'package:rnp_front/app/data/models/entities/subtask.dart';
import 'package:rnp_front/app/data/services/program_service.dart';
import 'package:rnp_front/app/data/services/user_form_service.dart';
import 'package:rnp_front/app/core/utils/profile_alert_manager.dart';
import 'package:rnp_front/app/data/providers/external/api_provider.dart';
import 'package:rnp_front/app/core/utils/constant.dart';
import '../views/asset_pdf_view.dart';
import 'dart:developer' as developer;

class ProgramController extends GetxController {
  final ProgramService programService = ProgramService();
  final UserFormService userFormService = UserFormService();
  final RxList<Task> programItems = <Task>[].obs;
  final RxBool isLoading = true.obs;
  final Rx<SubscriptionForm?> user = Rx<SubscriptionForm?>(null);
  BuildContext? _context;

  // Path to the PDF asset
  static const String ordreDuJourAssetPath = 'assets/ordre_du_jour.pdf';

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  // Set the context for showing alerts
  void setContext(BuildContext context) {
    _context = context;
    checkProfilePicture();
  }

  // Check if user has a profile picture
  void checkProfilePicture() {
    if (_context != null && user.value != null) {
      String? profilePicture;

      // Check if user has a profile picture
      if (user.value?.user.pathPicture != null &&
          user.value!.user.pathPicture!.isNotEmpty) {
        profilePicture = user.value?.user.pathPicture;
      }

      // Show alert if needed
      ProfileAlertManager.showProfilePictureAlertIfNeeded(
          _context!, profilePicture);
    }
  }

  // Fetch all necessary data
  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      // Load user data to check profile picture
      final userForm = await userFormService.getUserUUid();
      if (userForm != null) {
        user.value = userForm;
        checkProfilePicture();
      }

      // Get program items
      await getProgramItems();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load data: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getProgramItems() async {
    isLoading.value = true;
    try {
      final response = await programService.getTasks();
      if (response.isNotEmpty) {
        // Find expandable tasks and load their subtasks
        final List<Task> tasksWithSubtasks = [];

        for (var task in response) {
          if (task.isExpandable) {
            final subtasks = await getSubtasksForTask(task.id!);

            // Create a new task with the subtasks
            final taskWithSubtasks = Task(
              id: task.id,
              title: task.title,
              scheduledDate: task.scheduledDate,
              description: task.description,
              pathPicture: task.pathPicture,
              location: task.location,
              timeStart: task.timeStart,
              isExpandable: task.isExpandable,
              subtasks: subtasks,
              createdAt: task.createdAt,
              updatedAt: task.updatedAt,
              createdBy: task.createdBy,
            );

            tasksWithSubtasks.add(taskWithSubtasks);
          } else {
            tasksWithSubtasks.add(task);
          }
        }

        programItems.assignAll(tasksWithSubtasks);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load program items');
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<Subtask>> getSubtasksForTask(String taskId) async {
    try {
      return await programService.getSubtasks(taskId);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load subtasks');
      return [];
    }
  }

  // Method to preview the PDF from local assets
  void previewOrdreDuJourPdf() {
    developer.log('Opening PDF from asset: $ordreDuJourAssetPath');
    Get.to(() => AssetPdfView(
          assetPath: ordreDuJourAssetPath,
          title: 'Ordre du Jour',
        ));
  }
}
