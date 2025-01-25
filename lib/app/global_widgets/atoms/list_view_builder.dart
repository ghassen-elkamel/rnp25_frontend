import 'package:flutter/material.dart';
import 'package:rnp_front/app/global_widgets/atoms/spinner_progress_indicator.dart';

import 'empty_list.dart';

class AtomListViewBuilder<T> extends StatelessWidget {
  const AtomListViewBuilder({
    super.key,
    required this.items,
    required this.itemBuilder,
     this.physics,
    this.scrollDirection = Axis.vertical,
    this.shrinkWrap = false,
    this.isLoading = false,
  });

  final bool isLoading;
  final List<T> items;
  final Axis scrollDirection;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  final Widget Function(BuildContext context, int index, T item) itemBuilder;

  @override
  Widget build(BuildContext context) {
    if(isLoading) {
      return const AtomSpinnerProgressIndicator();
    }
    if(items.isEmpty) {
      return const AtomEmptyList();
    }

    return ListView.builder(
      itemCount: items.length,
      scrollDirection: scrollDirection,
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemBuilder: (context, index) {
        T item = items[index];
        return itemBuilder(context, index, item);
      },
    );
  }
}
