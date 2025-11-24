import 'package:flutter/material.dart';
import 'package:foodplanner/config/colors.dart';

// component for Scrollbar design - using this can facilitate conformity on all pages
class CustomScrollbar extends StatelessWidget {
  final Widget child;
  final ScrollController controller;

  const CustomScrollbar({
    super.key,
    required this.child,
    required this.controller,
  });


  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
      controller: controller,
        thumbVisibility: true,
        thumbColor: AppColors.background,
        trackVisibility: true,
        trackColor: AppColors.lightSecondary,
        trackRadius: const Radius.circular(20),
        thickness: 14,
        radius: const Radius.circular(20),
        interactive: true,
        padding: EdgeInsets.only(bottom: 20, right: 10),
        child: child,
    );
  }
}