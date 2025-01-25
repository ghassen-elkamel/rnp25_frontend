import 'dart:math' as math;

import 'package:rnp_front/app/core/values/colors.dart';
import 'package:flutter/material.dart';

class AtomSpinnerProgressIndicator extends StatefulWidget {
  final double? size;

  const AtomSpinnerProgressIndicator({super.key, this.size});

  @override
  State<AtomSpinnerProgressIndicator> createState() =>
      _AtomSpinnerProgressIndicatorState();
}

class _AtomSpinnerProgressIndicatorState
    extends State<AtomSpinnerProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Hero(
        tag: "loader",
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, child) {
            return Transform.rotate(
              angle: _controller.value * 2 * math.pi,
              child: child,
            );
          },
          child: Image.asset(
            "assets/icons/spinner.png",
            width: 80,
            color: primaryColor,
          ),
        ),
      ),
    );

    if (widget.size != null) {
      return SizedBox(
        width: widget.size,
        child: content,
      );
    }
    return content;
  }
}
