class ActivityModel {
  String? id;
  String? title;
  String? description;
  String? imageUrl;
  String? date;
  String? time;
  bool isFavorite;

  ActivityModel({
    this.id,
    this.title,
    this.description,
    this.imageUrl,
    this.date,
    this.time,
    this.isFavorite = false,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      date: json['date'],
      time: json['time'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'date': date,
      'time': time,
      'isFavorite': isFavorite,
    };
  }
}