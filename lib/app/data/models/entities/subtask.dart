class Subtask {
  final String? id;
  final String title;
  final int? durationMinutes;
  final bool? isCompleted;
  final String? timeStart;
  final String? timeEnd;
  final String? taskId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? createdBy;

  Subtask({
    this.id,
    required this.title,
    this.durationMinutes,
    this.isCompleted,
    this.timeStart,
    this.timeEnd,
    this.taskId,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
  });

  factory Subtask.fromJson(Map<String, dynamic> json) {
    return Subtask(
      id: json['id']?.toString(),
      title: json['title'],
      durationMinutes: json['durationMinutes'],
      isCompleted: json['isCompleted'],
      timeStart: json['timeStart'],
      timeEnd: json['timeEnd'],
      taskId: json['taskId']?.toString(),
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
      'durationMinutes': durationMinutes,
      'isCompleted': isCompleted,
      'timeStart': timeStart,
      'timeEnd': timeEnd,
      'taskId': taskId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'createdBy': createdBy,
    };
  }
}

List<Subtask> subtasksFromJson(Map<String, dynamic> json) {
  if (json['items'] == null) return [];
  return List<Subtask>.from(json['items'].map((x) => Subtask.fromJson(x)));
}
