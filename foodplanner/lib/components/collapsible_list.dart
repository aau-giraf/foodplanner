import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/models/pupil.dart';
import 'package:foodplanner/models/schoolClass.dart';

class CollapsibleList extends StatelessWidget {
  final Pupil? pupil;
  final SchoolClass? schoolClass;
  final Color? headerColor;
  final double? headerWidth;
  final double? bodyWidth;
  final String headerText;
  final bool isExpanded;
  final VoidCallback onFeedback;
  final VoidCallback onLunch;
  final VoidCallback onSettings;
  final VoidCallback onHeaderTap;

  const CollapsibleList ({
    super.key,
    this.pupil,
    this.schoolClass,
    this.headerColor = Colors.white,
    this.headerWidth,
    this.bodyWidth,

    required this.headerText,
    required this.isExpanded,
    required this.onFeedback,
    required this.onLunch,
    required this.onSettings,
    required this.onHeaderTap,
  });

  // Helper method for building a button in the body of each expandible element
  Widget _buildBodyButton(String text, {required IconData icon, required String iconType, required VoidCallback onTap}) {

    const double iconBoxSize = 30;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: AppTextStyles.buttonTextMedium),

            SizedBox(
              // fixed size to ensure icons of different type match
              width: iconBoxSize,
              height: iconBoxSize,
              child: FittedBox(
                fit: BoxFit.contain,
                child: iconType == "SFIcon" ? SFIcon(icon) : Icon(icon), // ensures both SF Icons and Material icons are accepted
              )
            )
          ],
        ),
      )
    );
  }

  // Helper method for building the widgets in the body of each element, if the collapsible list represents pupils
  List<Widget> _buildBodyWidgetsPupil(List<Widget> childrenWidgets){
    childrenWidgets = [
      _buildBodyButton(
        "Madpakke",
        iconType: 'Icon',
        icon: Icons.lunch_dining, // not sure if this should be outlined
        onTap: onLunch
      ),
      const Divider(height: 1),
      _buildBodyButton(
        "Feedback",
        iconType: 'SFIcon',
        icon: SFIcons.sf_message,
        onTap: onFeedback
      ),
      const Divider(height: 1),
      _buildBodyButton(
        "Indstillinger",
        iconType: 'Icon',
        icon: Icons.settings_outlined,
        onTap: onSettings
      ),
    ];
    return childrenWidgets;     
  }

  // OBS: only a placeholder
  List<Widget> _buildBodyWidgetsSchoolClass(List<Widget> childrenWidgets){
    return childrenWidgets;
  }

  List<Widget> _buildBodyWidgets() {
    List<Widget> childrenWidgets = [];

    if(pupil != null){
      childrenWidgets = _buildBodyWidgetsPupil(childrenWidgets); 
    } else if (schoolClass != null) {
      childrenWidgets = _buildBodyWidgetsSchoolClass(childrenWidgets);
    }

    return childrenWidgets;
  }

  // Helper method for building each header of collapsible element
  Widget _buildHeader(BuildContext context, double screenWidth){
    return InkWell(
      onTap: onHeaderTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: headerWidth ?? screenWidth - 90, // this fixes the width of each button, such that the scrollbar does not overlap - could be changed to a dynamic animation
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isExpanded? AppColors.primary : headerColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.textFieldBorderFocus.withAlpha(70),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              headerText,
              style: AppTextStyles.buttonTextMedium.copyWith(
                color: isExpanded ? AppColors.textSecondary : AppColors.textPrimary,
              ),
            ),
            // Animated rotation is used for the rotation of the arrow icon to the right of the header
            AnimatedRotation(
              turns: isExpanded ? 0.25 : 0, 
              duration: Duration(milliseconds: 300),
              child: SFIcon(
                SFIcons.sf_chevron_right,
                fontSize: 22,
                color: isExpanded ? AppColors.textSecondary : AppColors.textPrimary,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    final screenWidth = MediaQuery.of(context).size.width;

    return Column (
      children: [
        const SizedBox(height: 5),

        _buildHeader(context, screenWidth),

        // Animated size is used for the collapsible element that can be hidden or shown
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          // if isExpanded is true, the buttons should be shown
          child: isExpanded 
            ? Padding (
              padding: const EdgeInsets.only(bottom: 12),
              child: Center(
                child: Container (
                  width: bodyWidth ?? screenWidth - 155,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.textFieldBorderFocus.withAlpha(70),
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: _buildBodyWidgets(),
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(),
        ),
        const SizedBox(height: 8),
      ],
    );     
  }
}