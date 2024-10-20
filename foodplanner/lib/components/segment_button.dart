import 'package:flutter/material.dart';
import 'package:foodplanner/config/colors.dart';

class CustomSegmentButton extends StatefulWidget {
  final List<ButtonSegment<String>> buttonSegments;
  final Function(Set<String>) onTab;
  final Set<String> selected;
  final Color backgroundColor;
  final Color selectedBackgroundColor;
  final Color textColor;
  final Color selectedTextColor;

  const CustomSegmentButton({
    super.key,
    required this.buttonSegments,
    required this.onTab,
    required this.selected,
    this.backgroundColor = AppColors.background,
    this.selectedBackgroundColor = AppColors.primary,
    this.textColor = AppColors.textPrimary,
    this.selectedTextColor = AppColors.textSecondary,
  });

  @override
  State<CustomSegmentButton> createState() => _CustomSegmentButtonState();
}

class _CustomSegmentButtonState extends State<CustomSegmentButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SegmentedButton(
        segments: widget.buttonSegments,
        showSelectedIcon: false,
        selected: widget.selected,
        onSelectionChanged: widget.onTab,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return widget.selectedBackgroundColor;
              }
              return widget.backgroundColor;
            },
          ),
          foregroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return widget.selectedTextColor;
              }
              return widget.textColor;
            },
          ),
        ),
      ),
    );
  }
}
