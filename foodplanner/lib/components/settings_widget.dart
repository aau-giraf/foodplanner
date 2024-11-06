import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';

enum SettingsType { items, header }

class SettingsWidget extends StatefulWidget {
  final IconData leftIcon;
  final String title;
  final String subTitle;
  final dynamic cta;
  final SettingsType type;
  const SettingsWidget({
    super.key,
    required this.leftIcon,
    required this.title,
    this.subTitle = '',
    this.cta,
    required this.type,
  });

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  Widget item() {
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
            widget.cta ?? Container(),
            SizedBox(width: 10),
          ],
        ),
      ),
    );
  }

  Widget header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity, // Make the Card fill the whole width
        child: Card(
          color: AppColors.background,
          surfaceTintColor: AppColors.background,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(8.0), // Add rounded corners
                  child: Container(
                    color: AppColors.primary,
                    width: 60,
                    height: 60,
                    child: Center(
                      child: SFIcon(
                        widget.leftIcon,
                        fontSize: 36,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bigText.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  softWrap: true, // Allow text to wrap
                ),
                SizedBox(height: 10),
                Text(
                  widget.subTitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.standard,
                  softWrap: true, // Allow text to wrap
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == SettingsType.items) {
      return item();
    } else if (widget.type == SettingsType.header) {
      return header();
    } else {
      return Container();
    }
  }
}
