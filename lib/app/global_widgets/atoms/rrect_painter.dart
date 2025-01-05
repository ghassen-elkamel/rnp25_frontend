import 'dart:math';

import 'package:flutter/material.dart';
import '../../core/values/colors.dart';

class RRectPainter extends CustomPainter {
  final bool showDetails;
  final bool withNotification;
  const RRectPainter({
    Key? key,
    this.showDetails = false,
    required this.withNotification
  });

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint()
      ..color = primaryColor
      ..strokeWidth = 8.0;

    path.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, 93, showDetails ? 60 : 51),
        const Radius.circular(30)
      )
    );


    Path pathCorn = Path();
    Paint paintCorn = Paint()
      ..color = primaryColor
      ..strokeWidth = 10.0
      ..style = PaintingStyle.stroke;

    if(showDetails) {
      path.addRect(const Rect.fromLTWH(0, 30, 93, 40),);
      double degToRad(num deg) => deg * (pi / 180.0);
      pathCorn.arcTo(const Rect.fromLTWH(-25, 34, 30, 30), degToRad(0), degToRad(90), true);
      pathCorn.arcTo(const Rect.fromLTWH(88, 34, 30, 30), degToRad(90), degToRad(90), true);
    }


    canvas.drawPath(path, paint);
    canvas.drawPath(pathCorn, paintCorn);
    if(withNotification){
      Paint paintNotification = Paint()
        ..color = thirdColor
        ..strokeWidth = 10.0
        ..style = PaintingStyle.fill;

      canvas.drawCircle(const Offset(6, 6), 8, paintNotification);
    }


  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}