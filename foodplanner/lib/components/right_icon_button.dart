import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/config/colors.dart';


// new class for buttons with icon to the right-hand side
class RightIconButton extends StatelessWidget{
  final String buttonText;
  final SFIcon? sfIcon;
  final Icon? materialIcon;
  final Function()? onTab;
  final ImplicitlyAnimatedWidget? animatedWidget;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? customWidth;
  final MainAxisAlignment? alignment;

  const RightIconButton({
    super.key,
    required this.buttonText,
    this.sfIcon,
    this.materialIcon,
    this.onTab,
    this.animatedWidget,
    this.backgroundColor,
    this.foregroundColor,
    this.customWidth,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      // wrapping the button in a Directionality to ensure that the icon is on the right-hand side
      child: Directionality(
        textDirection: TextDirection.rtl, 
        child: CustomButton(
          onTab: onTab,
          text: buttonText,
          materialIcon: materialIcon,
          sfIcon: sfIcon, 
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
          size: ButtonSize.medium,
          mainAxisSize: MainAxisSize.max,
          animatedWidget: animatedWidget,
        ),
      ),
    );
  }

}