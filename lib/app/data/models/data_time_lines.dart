import 'package:flutter/material.dart';

import '../../core/values/colors.dart';

class DataTimeLines {
  final DateTime time;
  final double duration;
  final Color color;
  final String content;

  const DataTimeLines({
    required this.time,
    required this.content,
    this.duration = 1,
    this.color = blue,
  });

  static data() {
    return [
      DataTimeLines(time: DateTime(2023, 07, 07, 9, 00), content: "content 1 "),
      DataTimeLines(
        time: DateTime(2023, 07, 07, 9, 00),
        content: "content 2",
        color: red,
      ),
      DataTimeLines(
        time: DateTime(2023, 07, 07, 9, 15),
        content: "content 2 2",
        duration: 3,
        color: red,
      ),
      DataTimeLines(
          time: DateTime(2023, 07, 07, 10, 00), content: "content 3 "),
      DataTimeLines(
        time: DateTime(2023, 07, 07, 13, 00),
        content: "content 4",
        duration: 2,
      ),
      DataTimeLines(
        time: DateTime(2023, 07, 07, 16, 15),
        content: "content 5",
        duration: 1.75,
      ),
      DataTimeLines(time: DateTime(2023, 07, 07, 18, 00), content: "content 5"),
      DataTimeLines(time: DateTime(2023, 07, 07, 19, 00), content: "content 6"),
    ];
  }
}
