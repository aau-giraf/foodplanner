import 'package:flutter/material.dart';

class LoadingAnimation extends StatefulWidget {
  final String imagePath;
  final double size;

  const LoadingAnimation({required this.imagePath, this.size = 50.0, Key? key}) : super(key: key);

  @override
  _RotatingImageState createState() => _RotatingImageState();
}

class _RotatingImageState extends State<LoadingAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Image.asset(
        widget.imagePath,
        width: widget.size,
        height: widget.size,
      ),
    );
  }
}