import 'package:eco_trans/app/core/extensions/date/compare_dates.dart';
import 'package:flutter/material.dart';
List<DataEvent> eventFromJson(dynamic str) =>
    List<DataEvent>.from(str["items"].map((x) => DataEvent.fromJson(x)));

class DataEvent {
  DataEvent({
    required this.title,
    required this.date,
     this.color,
  });

  final String title;
  final DateTime date;
  final Color? color;

  factory DataEvent.fromJson(Map<String, dynamic>? json) {
    return DataEvent(
      title: json?["title"],
      color: json?["color"],
      date: DateTime.tryParse(json!["date"] ?? "") ?? DateTime.now(),
    );
  }

  static List<DataEvent> getData(DateTime date){
    List<DataEvent> data = [
      DataEvent(title: "title", date: DateTime(2023, 7, 7)),
      DataEvent(title: "title2", date: DateTime(2023, 7, 7)),
      DataEvent(title: "title3", date: DateTime(2023, 7, 7)),
      DataEvent(title: "title4", date: DateTime(2023, 7, 7)),
      DataEvent(title: "title5", date: DateTime(2023, 7, 7)),
      DataEvent(title: "aaaaaaaaa", date: DateTime(2023, 7, 8)),
      DataEvent(title: "vvvvvvvvv", date: DateTime(2023, 7, 8)),
      DataEvent(title: "bbbbbbbbb", date: DateTime(2023, 7, 9)),
      DataEvent(title: "ccccccccc", date: DateTime(2023, 7, 9)),
      DataEvent(title: "ssssssss", date: DateTime(2023, 7, 10)),
    ];
    
    return data.where((element) => element.date.inSameMonth(date)).toList();
  }
}
