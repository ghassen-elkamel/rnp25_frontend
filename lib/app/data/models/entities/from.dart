import 'package:rnp_front/app/data/models/entities/question.dart';

class FormEntity {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic createdBy;
  final String title;
  final String description;
  final bool isActive;
  final List<Question> questions;

  FormEntity({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.title,
    required this.description,
    required this.isActive,
    required this.questions,
  });

  factory FormEntity.fromJson(Map<String, dynamic> json) => FormEntity(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        createdBy: json["createdBy"],
        title: json["title"],
        description: json["description"],
        isActive: json["isActive"],
        questions: List<Question>.from(
            json["questions"].map((x) => Question.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "createdBy": createdBy,
        "title": title,
        "description": description,
        "isActive": isActive,
        "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
      };
}
