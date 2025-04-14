import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rnp_front/app/core/utils/constant.dart';
import 'package:rnp_front/app/global_widgets/atoms/attachement_button.dart';
import 'package:rnp_front/app/global_widgets/atoms/safe_image_network.dart';
import 'package:rnp_front/app/global_widgets/templates/app_scaffold.dart';
import '../controllers/program_management_controller.dart';

class ProgramManagementView extends GetView<ProgramManagementController> {
  const ProgramManagementView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'programManagement'.tr,
      selectedIndex: 7,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'events'.tr,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: Text('Add Event'.tr),
                    onPressed: () => _showTaskDialog(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tasks Panel
                    Expanded(
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              color: Colors.blue.shade100,
                              child: Text(
                                'Events'.tr,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: controller.tasks.length,
                                itemBuilder: (context, index) {
                                  final task = controller.tasks[index];
                                  return Card(
                                    margin: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () =>
                                          controller.loadSubtasks(task.id!),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            if (task.pathPicture != null &&
                                                task.pathPicture!.isNotEmpty)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 12.0),
                                                child: AtomSafeImageNetwork(
                                                  path: task.pathPicture,
                                                  host:
                                                  "$hostPath$apiPrefix/v1/task/image",
                                                  width: 60,
                                                  height: 60,
                                                  radius: 8,
                                                  onTapShowFullScreen: true,
                                                ),
                                              ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    task.title,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    DateFormat('yyyy-MM-dd')
                                                        .format(
                                                        task.scheduledDate),
                                                    style: const TextStyle(
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                  if (task.description != null)
                                                    Text(
                                                      task.description!,
                                                      maxLines: 2,
                                                      overflow:
                                                      TextOverflow.ellipsis,
                                                    ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.edit),
                                                  onPressed: () {
                                                    controller.editTask(task);
                                                    _showTaskDialog(context,
                                                        taskId: task.id);
                                                  },
                                                ),
                                                IconButton(
                                                  icon:
                                                  const Icon(Icons.delete),
                                                  onPressed: () =>
                                                      controller
                                                          .deleteTask(task.id!),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Subtasks Panel
                    Expanded(
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              color: Colors.green.shade100,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Sub-Events'.tr,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (controller.selectedTaskId.isNotEmpty)
                                    ElevatedButton.icon(
                                      icon: const Icon(Icons.add),
                                      label: Text('Add'.tr),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                      ),
                                      onPressed: () =>
                                          _showSubtaskDialog(context),
                                    ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Obx(() {
                                if (controller.selectedTaskId.isEmpty) {
                                  return Center(
                                    child: Text(
                                        'Select an event to view its sub-events'
                                            .tr),
                                  );
                                }
                                return ListView.builder(
                                  itemCount: controller.subtasks.length,
                                  itemBuilder: (context, index) {
                                    final subtask = controller.subtasks[index];
                                    return ListTile(
                                      title: Text(subtask.title),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          if (subtask.timeStart != null &&
                                              subtask.timeEnd != null)
                                            Text(
                                              '${subtask.timeStart} - ${subtask
                                                  .timeEnd}',
                                              style: const TextStyle(
                                                  color: Colors.amber),
                                            ),
                                          if (subtask.durationMinutes != null)
                                            Text(
                                              'Duration: ${subtask
                                                  .durationMinutes} minutes'
                                                  .tr,
                                            ),
                                        ],
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit),
                                            onPressed: () {
                                              controller.editSubtask(subtask);
                                              _showSubtaskDialog(context,
                                                  subtaskId: subtask.id);
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed: () =>
                                                controller
                                                    .deleteSubtask(subtask.id!),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  void _showTaskDialog(BuildContext context, {String? taskId}) {
    showDialog(
      context: context,
      builder: (context) =>
          Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            insetPadding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 40),
            child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.8,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    taskId == null ? 'Add Event'.tr : 'Edit Event'.tr,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: controller.titleController,
                            decoration: InputDecoration(labelText: 'Title'.tr),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: controller.descriptionController,
                            decoration:
                            InputDecoration(labelText: 'Description'.tr),
                            maxLines: 3,
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: controller.scheduledDateController,
                            decoration:
                            InputDecoration(labelText: 'Date (YYYY-MM-DD)'.tr),
                            onTap: () => _selectDate(context),
                            readOnly: true,
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: controller.timeStartController,
                            decoration:
                            InputDecoration(labelText: 'Time (HH:MM)'.tr),
                            keyboardType: TextInputType.datetime,
                            readOnly: true,
                            onTap: () =>
                                _selectTime(
                                    context, controller.timeStartController),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: controller.locationController,
                            decoration: InputDecoration(
                                labelText: 'Location'.tr),
                          ),

                          // Image selection section
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: controller.imageUrlController,
                                  decoration:
                                  InputDecoration(labelText: 'Image URL'.tr),
                                  enabled: !controller.hasSelectedImage.value,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text('or'.tr),
                              const SizedBox(width: 8),
                              AtomAttachementButton(
                                onPressed: (fileInfo) {
                                  controller.setSelectedImage(fileInfo);
                                },
                              ),
                            ],
                          ),

                          // Display selected image name if available
                          Obx(() =>
                          controller.selectedImageName.isNotEmpty
                              ? Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                const Icon(Icons.image, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    controller.selectedImageName.value,
                                    style: const TextStyle(fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.clear, size: 16),
                                  onPressed: () =>
                                      controller.clearSelectedImage(),
                                ),
                              ],
                            ),
                          )
                              : const SizedBox.shrink()),

                          Row(
                            children: [
                              Obx(() {
                                return Checkbox(
                                    value: controller.isExpandable.value,
                                    onChanged: (value) {
                                      controller.isExpandable.value =
                                          value ?? false;
                                    });
                              }),
                              Text('Has sub-events?'.tr),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          controller.clearTaskForm();
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'.tr),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          if (taskId == null) {
                            controller.createTask();
                          } else {
                            controller.updateTask(taskId);
                          }
                          Navigator.pop(context);
                        },
                        child: Text(taskId == null ? 'Add'.tr : 'Update'.tr),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      controller.scheduledDateController.text =
          DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  void _selectTime(BuildContext context,
      TextEditingController timeController) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _parseTimeFromController(timeController),
    );
    if (picked != null) {
      final String formattedTime =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute
          .toString()
          .padLeft(2, '0')}';
      timeController.text = formattedTime;
    }
  }

  TimeOfDay _parseTimeFromController(TextEditingController controller) {
    if (controller.text.isEmpty) {
      return TimeOfDay.now();
    }

    try {
      final parts = controller.text.split(':');
      return TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    } catch (e) {
      return TimeOfDay.now();
    }
  }

  void _showSubtaskDialog(BuildContext context, {String? subtaskId}) {
    if (controller.selectedTaskId.isEmpty) {
      Get.snackbar('Error'.tr, 'Please select an event first'.tr);
      return;
    }

    showDialog(
      context: context,
      builder: (context) =>
          Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            insetPadding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 80),
            child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.7,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    subtaskId == null ? 'Add Sub-Event'.tr : 'Edit Sub-Event'
                        .tr,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: controller.subtaskTitleController,
                            decoration: InputDecoration(labelText: 'Title'.tr),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: controller.subtaskTimeStartController,
                            decoration: InputDecoration(
                                labelText: 'Start Time'.tr),
                            readOnly: true,
                            onTap: () =>
                                _selectTime(
                                    context, controller
                                    .subtaskTimeStartController),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: controller.subtaskTimeEndController,
                            decoration: InputDecoration(
                                labelText: 'End Time'.tr),
                            readOnly: true,
                            onTap: () =>
                                _selectTime(
                                    context, controller
                                    .subtaskTimeEndController),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: controller.subtaskDurationController,
                            decoration:
                            InputDecoration(labelText: 'Duration (minutes)'.tr),
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          controller.clearSubtaskForm();
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'.tr),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          if (subtaskId == null) {
                            controller.createSubtask();
                          } else {
                            controller.updateSubtask(subtaskId);
                          }
                          Navigator.pop(context);
                        },
                        child: Text(subtaskId == null ? 'Add'.tr : 'Update'.tr),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
