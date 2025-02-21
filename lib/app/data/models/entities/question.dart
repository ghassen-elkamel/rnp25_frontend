class Question {
  final String id;
  final String question;
  final String type;
  final List<String> options;
  final bool isRequired;
  final int order;

  Question({
    required this.id,
    required this.question,
    required this.type,
    required this.options,
    required this.isRequired,
    required this.order,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json["id"],
        question: json["question"],
        type: json["type"],
        options: List<String>.from(json["options"].map((x) => x)),
        isRequired: json["isRequired"],
        order: json["order"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question": question,
        "type": type,
        "options": List<dynamic>.from(options.map((x) => x)),
        "isRequired": isRequired,
        "order": order,
      };
}
