import 'package:flutter/material.dart';
import 'package:eco_trans/app/core/extensions/date_time/get_lines.dart';
import '../../core/theme/text.dart';
import '../../core/utils/date.dart';
import '../../core/values/colors.dart';
import '../../data/models/data_time_lines.dart';
import '../atoms/time_lines_item.dart';

class MoleculeTimeLines extends StatelessWidget {
  final DateTime date;
  final int start;
  final int end;
  final int length;
  final double itemHeight;
  final List<DataTimeLines> data;
  final void Function(DateTime newDate)? next;
  final void Function(DateTime newDate)? previous;

  const MoleculeTimeLines({
    super.key,
    required this.date,
    this.start = 8,
    this.end = 20,
    this.itemHeight = 60,
    required this.data,
    this.next,
    this.previous,
  })  : length = end - start + 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () =>
                    previous?.call(date.subtract(const Duration(days: 1))),
                icon: const Icon(
                  Icons.navigate_before,
                  color: greyDark,
                  size: 35,
                ),
              ),
              CustomText.xxl(
                UtilsDate.formatEEEED(date),
                color: primaryColor,
              ),
              IconButton(
                  onPressed: () =>
                      next?.call(date.add(const Duration(days: 1))),
                  icon: const Icon(
                    Icons.navigate_next,
                    color: greyDark,
                    size: 35,
                  )),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(
                length,
                (index) => AtomTimeLinesItem(
                  itemHeight: itemHeight,
                  index: start + index,
                  data: data.getLines(start + index),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
