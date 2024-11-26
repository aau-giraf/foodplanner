import 'package:flutter/material.dart';

class CustomSquareCameraOverlay extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.5);

    // Define the size, position, and corner radius of the rounded square cutout
    final double squareSize = size.width * 0.95; // Adjust square size as needed
    final double left = (size.width - squareSize) / 2;
    final double top = (size.height - squareSize) / 2;
    final double right = left + squareSize;
    final double bottom = top + squareSize;
    final double borderRadius = 20.0; // Adjust for desired roundness

    // Draw the overlay with a transparent rounded square in the center
    final overlayPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height)) // Full screen
      ..addRRect(RRect.fromLTRBR(left, top, right, bottom, Radius.circular(borderRadius))) // Rounded cutout
      ..fillType = PathFillType.evenOdd; // Make the cutout transparent

    canvas.drawPath(overlayPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // No need to repaint unless dimensions change
  }
}