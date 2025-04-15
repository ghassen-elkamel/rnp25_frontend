class CreateEventDto {
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String? picturePath;

  CreateEventDto(
      {required this.title,
      required this.description,
      required this.startDate,
      required this.endDate,
      this.picturePath});

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        if (picturePath != null) "picturePath": picturePath
      };
}
