import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const SearchField({
    super.key,
    required this.controller,
    this.hintText = 'Søg...',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
