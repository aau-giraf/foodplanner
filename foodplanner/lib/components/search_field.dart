import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final Color? backgroundColor;
  final double? elevation;
  final double horizontalPadding;
  final double verticalPadding;
  final Color? cursorColor;
  final double borderRadius;
  final List<BoxShadow>? boxShadow;

  const SearchField({
    super.key,
    required this.controller,
    this.hintText = 'Søg...',
    this.onChanged,
    this.backgroundColor = AppColors.background,
    this.elevation = 2,
    this.horizontalPadding = 20,
    this.verticalPadding = 0,
    this.cursorColor,
    this.borderRadius = 8,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      child: SizedBox(
        width: double.infinity,
        child: Card(
          elevation: elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: boxShadow,
            ),
            child: Row(
              children: [
                SFIcon(
                  SFIcons.sf_magnifyingglass,
                  color: AppColors.textPrimary,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: hintText,
                      border: InputBorder.none,
                    ),
                    style: AppTextStyles.bigText,
                    onChanged: onChanged,
                    cursorColor: cursorColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}