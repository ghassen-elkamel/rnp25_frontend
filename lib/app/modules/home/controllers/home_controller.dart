import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rnp_front/app/data/models/entities/subscription_form.dart';
import 'package:rnp_front/app/data/services/auth_service.dart';

import '../../../core/utils/profile_alert_manager.dart';
import '../../../data/models/activity_model.dart';
import '../../../data/models/entities/subtask.dart';
import '../../../data/models/entities/task.dart';
import '../../../data/models/sponsor_model.dart';
import '../../../data/services/program_service.dart';
import '../../../data/services/user_form_service.dart';

class HomeController extends GetxController {
  final ProgramService programService = ProgramService();
  final RxList<Task> programItems = <Task>[].obs;
  AuthService authService = AuthService();
  final RxBool isLoading = true.obs;
  final RxList<ActivityModel> activities = <ActivityModel>[].obs;
  final RxList<SponsorModel> sponsors = <SponsorModel>[].obs;
  final Rx<SubscriptionForm?> user = Rx<SubscriptionForm?>(null);

  Timer? _refreshTimer;
  BuildContext? _context;
  final UserFormService userFormService = UserFormService();

  @override
  void onInit() {
    super.onInit();
    fetchData();

    // Set up a timer to periodically refresh user data
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      refreshUserData();
    });

    // Delay checking for profile picture until view is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkProfilePicture();
    });
  }

  void setContext(BuildContext context) {
    _context = context;
    checkProfilePicture();
  }

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

  @override
  void onClose() {
    _refreshTimer?.cancel();
    super.onClose();
  }

  Future<List<Subtask>> getSubtasksForTask(String taskId) async {
    try {
      return await programService.getSubtasks(taskId);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load subtasks');
      return [];
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

  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      // Fetch user data
      final userData = await authService.getMe();
      if (userData != null) {
        // We need to access the user's subscription form
        final userForm = await userFormService.getUserUUid();
        if (userForm != null) {
          user.value = userForm;
          checkProfilePicture();
        }
      }

      // Fetch tasks
      await getProgramItems();

      // Mock sponsors data for now - this can be replaced with actual API calls
      sponsors.assignAll([
        SponsorModel(
            id: '1',
            name: 'Sponsor 1',
            logoUrl: 'assets/images/logo-small.png'),
        SponsorModel(
            id: '2',
            name: 'Sponsor 2',
            logoUrl: 'assets/images/logo-small.png'),
        SponsorModel(
            id: '3',
            name: 'Sponsor 3',
            logoUrl: 'assets/images/logo-small.png'),
      ]);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load data: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void toggleFavorite(String? activityId) {
    if (activityId == null) return;

    final index =
        activities.indexWhere((activity) => activity.id == activityId);
    if (index != -1) {
      final activity = activities[index];
      activity.isFavorite = !activity.isFavorite;
      activities[index] = activity;
    }
  }

  // Method to refresh only the user data
  Future<void> refreshUserData() async {
    try {
      final userForm = await userFormService.getUserUUid();
      if (userForm != null) {
        user.value = userForm;
        checkProfilePicture();
      }
    } catch (e) {
      // Silent failure, we don't want to show a snackbar for background refresh
      print('Failed to refresh user data: ${e.toString()}');
    }
  }
}
