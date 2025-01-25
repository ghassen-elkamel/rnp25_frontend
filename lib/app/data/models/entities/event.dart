List<Event> eventsFromJson(dynamic str) =>
    List<Event>.from(str["items"].map((x) => Event.fromJson(x)));

class Event {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int createdBy;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final dynamic pathPicture;

  Event({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.pathPicture,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        createdBy: json["createdBy"],
        title: json["title"],
        description: json["description"],
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
        location: json["location"],
        pathPicture: json["pathPicture"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "createdBy": createdBy,
        "title": title,
        "description": description,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        "location": location,
        "pathPicture": pathPicture,
      };
}
