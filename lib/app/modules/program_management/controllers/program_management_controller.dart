import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rnp_front/app/core/utils/file_picker.dart';
import 'package:rnp_front/app/data/models/entities/subtask.dart';
import 'package:rnp_front/app/data/models/entities/task.dart';
import 'package:rnp_front/app/data/models/file_info.dart';
import 'package:rnp_front/app/data/services/program_service.dart';

class ProgramManagementController extends GetxController {
  final ProgramService _programService = ProgramService();

  final RxList<Task> tasks = <Task>[].obs;
  final RxList<Subtask> subtasks = <Subtask>[].obs;
  final RxBool isLoading = false.obs;
  final RxString selectedTaskId = ''.obs;
  final RxBool isExpandable = false.obs;

  // File upload related
  final Rx<FileInfo?> selectedImage = Rx<FileInfo?>(null);
  final RxString selectedImageName = ''.obs;
  final RxBool hasSelectedImage = false.obs;
  final RxBool isUploading = false.obs;

  // Form controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final scheduledDateController = TextEditingController();
  final locationController = TextEditingController();
  final timeStartController = TextEditingController();
  final imageUrlController = TextEditingController();

  // Subtask form controllers
  final subtaskTitleController = TextEditingController();
  final subtaskDurationController = TextEditingController();
  final subtaskTimeStartController = TextEditingController();
  final subtaskTimeEndController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  @override
  void onClose() {

    super.onClose();
  }

  Future<void> loadTasks() async {
    try {
      isLoading.value = true;
      final loadedTasks = await _programService.getTasks();
      tasks.assignAll(loadedTasks);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load tasks');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadSubtasks(String taskId) async {
    try {
      isLoading.value = true;
      final loadedSubtasks = await _programService.getSubtasks(taskId);
      subtasks.assignAll(loadedSubtasks);
      selectedTaskId.value = taskId;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load subtasks');
    } finally {
      isLoading.value = false;
    }
  }

  void setSelectedImage(FileInfo fileInfo) {
    selectedImage.value = fileInfo;
    selectedImageName.value = fileInfo.fileName;
    hasSelectedImage.value = true;
  }

  void clearSelectedImage() {
    selectedImage.value = null;
    selectedImageName.value = '';
    hasSelectedImage.value = false;
  }

  Future<void> pickImage(BuildContext context) async {
    FileInfo? fileInfo = await CustomFilePicker.showPicker(
      context: context,
      withDocs: false,
    );

    if (fileInfo != null) {
      setSelectedImage(fileInfo);
    }
  }

  Future<void> createTask() async {
    try {
      isLoading.value = true;

      // Parse date string
      final dateStr = scheduledDateController.text;
      DateTime scheduledDate;

      try {
        scheduledDate = DateTime.parse(dateStr);
      } catch (e) {
        // If parsing fails, try simpler format
        scheduledDate = DateTime.parse('${dateStr}T00:00:00');
      }

      final task = Task(
        title: titleController.text,
        scheduledDate: scheduledDate,
        description: descriptionController.text,
        location: locationController.text,
        timeStart: timeStartController.text,
      );

      final createdTask =
          await _programService.createTask(task, selectedImage.value);
      if (createdTask != null) {
        tasks.add(createdTask);
        clearTaskForm();
        Get.snackbar('Success', 'Event created successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create event: $e');
      print('Error creating task: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateTask(String taskId) async {
    try {
      isLoading.value = true;

      final dateStr = scheduledDateController.text;
      DateTime scheduledDate;

      try {
        scheduledDate = DateTime.parse(dateStr);
      } catch (e) {
        // If parsing fails, try simpler format
        scheduledDate = DateTime.parse('${dateStr}T00:00:00');
      }

      final task = Task(
        id: taskId,
        title: titleController.text,
        scheduledDate: scheduledDate,
        description: descriptionController.text,
        location: locationController.text,
        timeStart: timeStartController.text,
        isExpandable: isExpandable.value,
      );

      final updatedTask = await _programService.updateTask(taskId, task,
          selectedImage.value);
      if (updatedTask != null) {
        final index = tasks.indexWhere((t) => t.id == taskId);
        if (index != -1) {
          tasks[index] = updatedTask;
        }
        clearTaskForm();
        Get.snackbar('Success', 'Event updated successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update event');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      isLoading.value = true;
      final success = await _programService.deleteTask(taskId);
      if (success) {
        tasks.removeWhere((task) => task.id == taskId);
        Get.snackbar('Success', 'Event deleted successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete event');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createSubtask() async {
    if (selectedTaskId.isEmpty) {
      Get.snackbar('Error', 'Please select an event first');
      return;
    }

    try {
      isLoading.value = true;
      // Check if taskId is a number and convert to UUID format if needed
      String taskId = selectedTaskId.value;

      final subtask = Subtask(
        title: subtaskTitleController.text,
        durationMinutes: int.tryParse(subtaskDurationController.text),
        timeStart: subtaskTimeStartController.text,
        timeEnd: subtaskTimeEndController.text,
        taskId: taskId,
      );

      try {
        final createdSubtask = await _programService.createSubtask(subtask);
        if (createdSubtask != null) {
          subtasks.add(createdSubtask);
          clearSubtaskForm();
          Get.snackbar('Success', 'Sub-event created successfully');
        }
      } catch (e) {
        print('Subtask creation error: $e');
        Get.snackbar(
            'Error', 'Failed to create sub-event: The task ID must be a UUID');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create sub-event: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateSubtask(String subtaskId) async {
    try {
      isLoading.value = true;
      final subtask = Subtask(
        id: subtaskId,
        title: subtaskTitleController.text,
        durationMinutes: int.tryParse(subtaskDurationController.text),
        timeStart: subtaskTimeStartController.text,
        timeEnd: subtaskTimeEndController.text,
        taskId: selectedTaskId.value,
      );

      final updatedSubtask =
          await _programService.updateSubtask(subtaskId, subtask);
      if (updatedSubtask != null) {
        final index = subtasks.indexWhere((s) => s.id == subtaskId);
        if (index != -1) {
          subtasks[index] = updatedSubtask;
        }
        clearSubtaskForm();
        Get.snackbar('Success', 'Sub-event updated successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update sub-event');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteSubtask(String subtaskId) async {
    try {
      isLoading.value = true;
      final success = await _programService.deleteSubtask(subtaskId);
      if (success) {
        subtasks.removeWhere((subtask) => subtask.id == subtaskId);
        Get.snackbar('Success', 'Sub-event deleted successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete sub-event');
    } finally {
      isLoading.value = false;
    }
  }

  void clearTaskForm() {
    titleController.clear();
    descriptionController.clear();
    scheduledDateController.clear();
    locationController.clear();
    timeStartController.clear();
    imageUrlController.clear();
    isExpandable.value = false;
    clearSelectedImage();
  }

  void clearSubtaskForm() {
    subtaskTitleController.clear();
    subtaskDurationController.clear();
    subtaskTimeStartController.clear();
    subtaskTimeEndController.clear();
  }

  void editTask(Task task) {
    titleController.text = task.title;
    descriptionController.text = task.description ?? '';
    scheduledDateController.text =
        task.scheduledDate.toIso8601String().split('T')[0];
    locationController.text = task.location ?? '';
    timeStartController.text = task.timeStart ?? '';
    imageUrlController.text = task.pathPicture ?? '';
    isExpandable.value = task.isExpandable;
    clearSelectedImage();
  }

  void editSubtask(Subtask subtask) {
    subtaskTitleController.text = subtask.title;
    subtaskDurationController.text = subtask.durationMinutes?.toString() ?? '';
    subtaskTimeStartController.text = subtask.timeStart ?? '';
    subtaskTimeEndController.text = subtask.timeEnd ?? '';
  }
}
