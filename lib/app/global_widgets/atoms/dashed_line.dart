import 'package:eco_trans/app/core/values/colors.dart';
import 'package:flutter/material.dart';


class DashedLine extends StatelessWidget {
  final double? height;
  const DashedLine({super.key, this.height });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CustomPaint(
        painter: DashedLinePainter(),
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 8;
    double dashSpace = 4;
    double startY = 0;

    final paint = Paint()
      ..color = grey
      ..strokeWidth = 2;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}