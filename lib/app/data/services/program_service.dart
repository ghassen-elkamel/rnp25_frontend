import 'package:rnp_front/app/core/extensions/map/map_extension.dart';
import 'package:rnp_front/app/data/providers/external/api_provider.dart';
import 'package:rnp_front/app/data/models/file_info.dart';

import '../models/entities/subtask.dart';
import '../models/entities/task.dart';

class ProgramService {
  // Task Operations
  Future<List<Task>> getTasks() async {
    final response = await ApiProvider().get(HttpParamsGetDelete(
      endpoint: '/v1/task',
    ));
    if (response != null && response.containsKeyNotNull('items')) {
      return tasksFromJson(response);
    }
    return <Task>[];
  }

  Future<Task?> createTask(Task task,FileInfo? file) async {
    final response = await ApiProvider().post(HttpParamsPostPut(
      endpoint: '/v1/task',
      body: task.toJson(),
      files: file != null ? [file] : [],
      isFormData: file != null,
    ));
    if (response != null) {
      return Task.fromJson(response);
    }
    return null;
  }

  Future<Task?> updateTask(String id, Task task,FileInfo? file) async {
    final response = await ApiProvider().patch(HttpParamsPostPut(
      endpoint: '/v1/task/$id',
      body: task.toJson(),
      files: file != null ? [file] : [],
      isFormData: file != null,
    ));
    if (response != null) {
      return Task.fromJson(response);
    }
    return null;
  }

  Future<bool> deleteTask(String id) async {
    final response = await ApiProvider().delete(HttpParamsGetDelete(
      endpoint: '/v1/task/$id',
    ));
    return response != null;
  }

  Future<String?> uploadTaskImage(FileInfo fileInfo) async {
    final response = await ApiProvider().post(
      HttpParamsPostPut(
        endpoint: '/v1/task/upload',
        body: {},
        isFormData: true,
        file: fileInfo,
      ),
    );

    if (response != null && response.containsKey('path')) {
      // Just return the filename, which is what the backend expects for pathPicture
      return response['path'];
    }
    return null;
  }

  // Subtask Operations
  Future<List<Subtask>> getSubtasks(String taskId) async {
    final response = await ApiProvider().get(HttpParamsGetDelete(
      endpoint: '/v1/subtask',
      queryParam: {'taskId': taskId},
    ));
    if (response != null && response.containsKeyNotNull('items')) {
      return subtasksFromJson(response);
    }
    return <Subtask>[];
  }

  Future<Subtask?> createSubtask(Subtask subtask) async {
    final response = await ApiProvider().post(HttpParamsPostPut(
      endpoint: '/v1/subtask',
      body: subtask.toJson(),
    ));
    if (response != null) {
      return Subtask.fromJson(response);
    }
    return null;
  }

  Future<Subtask?> updateSubtask(String id, Subtask subtask) async {
    final response = await ApiProvider().patch(HttpParamsPostPut(
      endpoint: '/v1/subtask/$id',
      body: subtask.toJson(),
    ));
    if (response != null) {
      return Subtask.fromJson(response);
    }
    return null;
  }

  Future<bool> deleteSubtask(String id) async {
    final response = await ApiProvider().delete(HttpParamsGetDelete(
      endpoint: '/v1/subtask/$id',
    ));
    return response != null;
  }
  finOne(String id) async {
    final response = await ApiProvider().get(HttpParamsGetDelete(
      endpoint: '/v1/task/$id',
    ));
    if (response != null) {
      return Task.fromJson(response);
    }
    return null;
  }
}
