import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';

class CustomListItem extends StatelessWidget {
  final IconData? leftIcon;
  final String title;
  final bool isHighlighted;
  final VoidCallback onTap;

  const CustomListItem({
    Key? key,
    this.leftIcon,
    required this.title,
    required this.isHighlighted,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Card(
        elevation: 2,
        color: AppColors.background,
        surfaceTintColor: AppColors.background,
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              if (leftIcon != null)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 15.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Container(
                      color: AppColors.primary,
                      width: 40,
                      height: 40,
                      child: Center(
                        child: SFIcon(
                          leftIcon!,
                          fontSize: 25,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.bigText.copyWith(
                    fontWeight:
                        isHighlighted ? FontWeight.bold : FontWeight.normal,
                    color: isHighlighted ? Colors.blue : Colors.black,
                  ),
                  softWrap: true,
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }
}
