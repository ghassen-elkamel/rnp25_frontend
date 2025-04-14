import 'package:rnp_front/app/data/models/entities/subtask.dart';

List<Task> tasksFromJson(Map<String, dynamic> json) {
  if (json['items'] == null) return [];
  return List<Task>.from(json['items'].map((x) => Task.fromJson(x)));
}

class Task {
  final String? id;
  final String title;
  final DateTime scheduledDate;
  final String? description;
  final String? pathPicture;
  final String? location;
  final String? timeStart;
  final bool isExpandable;
  final List<Subtask>? subtasks;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? createdBy;

  Task({
    this.id,
    required this.title,
    required this.scheduledDate,
    this.description,
    this.pathPicture,
    this.location,
    this.timeStart,
    this.isExpandable = false,
    this.subtasks,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id']?.toString(),
      title: json['title'],
      scheduledDate: DateTime.parse(json['scheduledDate']),
      description: json['description'],
      pathPicture: json['pathPicture'],
      location: json['location'],
      timeStart: json['timeStart'],
      isExpandable: json['isExpandable'] ?? false,
      subtasks: json['subtasks'] != null
          ? List<Subtask>.from(json['subtasks'].map((x) => Subtask.fromJson(x)))
          : null,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      createdBy: json['createdBy']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'scheduledDate': scheduledDate.toIso8601String(),
      'description': description,
      'pathPicture': pathPicture,
      'location': location,
      'timeStart': timeStart,
      'isExpandable': isExpandable.toString(),
      'subtasks': subtasks?.map((x) => x.toJson()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'createdBy': createdBy,
    };
  }
}
