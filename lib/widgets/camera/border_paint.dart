import 'package:flutter/material.dart';

class BorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double sh = size.height; // for convenient shortage
    double sw = size.width; // for convenient shortage
    double cornerSide = sh * 0.1; // desirable value for corners side

    Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Path path = Path()
      ..moveTo(cornerSide + 5, 0)
      ..quadraticBezierTo(0, 0, 0, cornerSide + 5)
      ..moveTo(0, sh - cornerSide - 5)
      ..quadraticBezierTo(0, sh, cornerSide + 5, sh)
      ..moveTo(sw - cornerSide - 5, sh)
      ..quadraticBezierTo(sw, sh, sw, sh - cornerSide - 5)
      ..moveTo(sw, cornerSide + 5)
      ..quadraticBezierTo(sw, 0, sw - cornerSide - 5, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(BorderPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(BorderPainter oldDelegate) => false;
}
