import 'package:flutter/material.dart';
import 'package:rnp_front/app/core/values/colors.dart';
import 'package:rnp_front/app/data/enums/order.dart';
import 'package:rnp_front/app/data/models/item_header.dart';

import '../../core/theme/text.dart';

class AtomHeader extends StatefulWidget {
  final List<ItemHeader> headers;
  final double actionsWidth;
  final bool showButtons;

  const AtomHeader({
    super.key,
    required this.headers,
    required this.actionsWidth,
    this.showButtons = true,
  });

  @override
  State<AtomHeader> createState() => _AtomHeaderState();
}

class _AtomHeaderState extends State<AtomHeader> {
  Order order = Order.ASC;
  ItemHeader? selectedItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          ...widget.headers.map(
            (header) {
              Widget headerContent = CustomText.l(
                header.name,
                maxLines: 1,
                textAlign: TextAlign.start,
                color: primaryColor,
              );
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, ),
                  child: header.onChangeOrder == null ? headerContent : InkWell(
                    onTap: () {
                      setState(() {
                        order = order.inv;
                        selectedItem = header;
                      });
                      header.onChangeOrder?.call(order);
                    },
                    child: Row(
                      children: [
                        Flexible(
                          child: headerContent,
                        ),
                        const SizedBox(width: 3),
                        Icon(
                          order == Order.ASC && selectedItem == header
                              ? Icons.arrow_upward_sharp
                              : Icons.arrow_downward_sharp,
                          color:
                          selectedItem == header ? secondColor : grey,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          if (widget.showButtons)
            SizedBox(
              width: widget.actionsWidth,
              child: const Icon(
                Icons.settings,
                color: primaryColor,
              ),
            ),
        ],
      ),
    );
  }
}
