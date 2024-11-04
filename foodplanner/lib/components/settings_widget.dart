import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';

class SettingsWidget extends StatefulWidget {
  final IconData leftIcon;
  final String title;
  final dynamic cta;
  const SettingsWidget({
    super.key,
    required this.leftIcon,
    required this.title,
    required this.cta,
  });

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        color: AppColors.background,
        surfaceTintColor: AppColors.background,
        child: Row(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0), // Add rounded corners
                child: Container(
                  color: AppColors.primary,
                  width: 50,
                  height: 50,
                  child: Center(
                    child: SFIcon(
                      widget.leftIcon,
                      fontSize: 24,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                widget.title,
                style: AppTextStyles.bigText,
                softWrap: true, // Allow text to wrap
              ),
            ),
            widget.cta,
            SizedBox(width: 10),
            /* IconButton(
              icon: SFIcon(SFIcons.sf_chevron_forward),
              onPressed: () {},
            ), */
          ],
        ),
      ),
    );
  }
}
