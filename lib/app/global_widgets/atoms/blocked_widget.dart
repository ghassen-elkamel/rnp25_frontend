import 'package:flutter/material.dart';
import '../../core/values/colors.dart';

class AtomBlockedWidget extends StatelessWidget {
  final bool isBlocked;
  final Widget child;
  const AtomBlockedWidget({
    super.key,
    required this.child,
    this.isBlocked = false
  });

  @override
  Widget build(BuildContext context) {
    if(!isBlocked){
      return child;
    }
    return Stack(
      children: [
        child,
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: grey,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
