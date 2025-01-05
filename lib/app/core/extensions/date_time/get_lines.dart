import '../../../data/models/data_time_lines.dart';
import 'package:flutter/material.dart';

import '../../theme/text.dart';
extension GetLines on List<DataTimeLines> {
  List<DataTimeLines> getLines(int h) {
    return where((element) => element.time.hour == h).toList();
  }

  Widget toWidget(double itemHeight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          width: 32,
        ),
        ...map(
              (e) => Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                top: e.time.minute == 0 ? 0 : itemHeight / (60 / e.time.minute),
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: e.color.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SizedBox(
                  height: (itemHeight * e.duration),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomText.m(e.content),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 32,
        ),
      ],
    );
  }
}
