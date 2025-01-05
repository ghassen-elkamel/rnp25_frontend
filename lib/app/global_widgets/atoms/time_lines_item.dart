import 'package:flutter/material.dart';
import 'package:eco_trans/app/core/extensions/date_time/get_lines.dart';
import '../../core/theme/text.dart';
import '../../data/models/data_time_lines.dart';

class AtomTimeLinesItem extends StatelessWidget {
  const AtomTimeLinesItem({
    super.key,
    required this.itemHeight,
    required this.index,
    required this.data,
  });

  final double itemHeight;
  final int index;
  final List<DataTimeLines> data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: itemHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            children: [
              SizedBox(
                width: 32,
                child: CustomText.sm(
                  index.toString(),
                ),
              ),
              const Expanded(child: Divider()),
              const SizedBox(
                width: 32,
              ),
            ],
          ),
          Positioned(
            top: 8,
            width: MediaQuery.of(context).size.width,
            child: data.toWidget(itemHeight),
          )
        ],
      ),
    );
  }
}