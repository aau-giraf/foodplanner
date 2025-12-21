import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget{
  final String? title;
  final Widget child;
  final Clip? clipBehavior;
  final Color color;

  const CardContainer({
    super.key,
    this.title,
    this.clipBehavior,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(15),
      ),
      color: color,
      elevation: 3,
      margin: const EdgeInsets.all(15),
      clipBehavior: clipBehavior,
      child: child,
    );
  }
}