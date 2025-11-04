import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';

class CustomListItem extends StatelessWidget {
  final IconData? leftIcon;
  final TextStyle? leftIconStyle;
  final String title;
  final bool isHighlighted;
  final bool isLastItem;
  final VoidCallback onTap;
  final bool isTapped;

  const CustomListItem({
    super.key,
    this.leftIcon,
    this.leftIconStyle,
    required this.title,
    required this.isHighlighted,
    required this.isLastItem,
    required this.onTap,
    required this.isTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Row(
              children: [
                if (leftIcon != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6.0, vertical: 6.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Container(
                        color: AppColors.primary,
                        width: 40,
                        height: 40,
                        child: Center(
                          child: SFIcon(
                            leftIcon!,
                            fontSize: leftIconStyle?.fontSize ?? 25,
                            color:
                                leftIconStyle?.color ?? AppColors.textSecondary,
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
                      color: isHighlighted ? AppColors.primary : Colors.black,
                    ),
                    softWrap: true,
                  ),
                ),
                Icon(
                  isTapped
                      ? SFIcons.sf_chevron_down
                      : SFIcons.sf_chevron_forward,
                ),
                SizedBox(width: 10),
              ],
            ),
            if (!isLastItem)
              Padding(
                padding: const EdgeInsets.only(left: 50),
                child: Container(
                  margin: const EdgeInsets.only(top: 6.0),
                  height: 1.0,
                  color: Colors.grey,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
