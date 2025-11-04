import 'package:flutter/material.dart';

class CustomSquareCameraOverlay extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withValues(alpha: 0.5);

    final double squareSize =
        size.width < size.height ? size.width : size.height;

    final double left = (size.width - squareSize) / 2;
    final double top = (size.height - squareSize) / 2;
    final double right = left + squareSize;
    final double bottom = top + squareSize;
    final double borderRadius = 20.0;

    final overlayPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromLTRBR(left, top, right, bottom,
          Radius.circular(borderRadius))) // Rounded cutout
      ..fillType = PathFillType.evenOdd; // Make the cutout transparent

    canvas.drawPath(overlayPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
