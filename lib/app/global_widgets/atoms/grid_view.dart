import 'package:flutter/material.dart';

class AtomGridView extends StatelessWidget {
  final int crossAxisCount;
  final List<Widget> children;
  final bool addCrowding;
  final bool withBuilder;
  final bool shrinkWrap;
  final EdgeInsetsGeometry padding;

  const AtomGridView({
    super.key,
    this.crossAxisCount = 2,
    this.addCrowding = false,
    this.withBuilder = true,
    this.shrinkWrap = false,
    required this.children,
    this.padding = const EdgeInsets.all(24),
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> rows = [];
    List<Widget> row = [];
    for (int i = 0; i < children.length; i++) {
      row.add(Expanded(
          child: Padding(
            padding: padding,
            child: children[i],
          )));
      if (row.length == crossAxisCount) {
        rows.add(
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: row,
          ),
        );
        row = [];
      }
    }
    if (row.isNotEmpty) {
      if (addCrowding) {
        for (int i = row.length; i < crossAxisCount; i++) {
          row.add(const Expanded(child: SizedBox()));
        }
      }

      rows.add(Row(children: row));
    }

    Widget content = Padding(
      padding: padding,
      child: withBuilder
          ? ListView.builder(
        primary: true,
        itemCount: rows.length,
        shrinkWrap: shrinkWrap,

        itemBuilder: (context, index) {
          return rows[index];
        },
      )
          : shrinkWrap
          ? Column(
        children: rows,
      )
          : SingleChildScrollView(
        primary: true,
        child: Column(
          children: rows,
        ),
      ),
    );
    return shrinkWrap
        ? content
        : Scrollbar(
      thumbVisibility: true,
      thickness: 10,
      radius: const Radius.circular(20),
      scrollbarOrientation: ScrollbarOrientation.left,
      child: ScrollConfiguration(
        behavior:
        ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: content,
      ),
    );
  }
}
