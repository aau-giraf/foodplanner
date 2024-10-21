import 'package:flutter/material.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';

class CustomIconButton extends StatelessWidget {
  final Function()? onTab;
  final Icon icon;
  final String text;
  final Color mainColor;

  const CustomIconButton({
    super.key,
    required this.onTab,
    required this.icon,
    this.text = '',
    this.mainColor = AppColors.primary, 
  });

  @override
  Widget build(BuildContext context) {
    return Column (
      children: [
        SizedBox(height: 8),
        IconButton (
          icon: icon,
            onPressed: onTab,
          style: ElevatedButton.styleFrom(
            iconColor: mainColor,
          ),
        ),
        Text(
          text,
          style: AppTextStyles.standard,
        ),
      ]
    );
  }
}

class CustomElevatedButton extends StatelessWidget {
  final Function()? onTab;
  final String text;
  final double height;
  final double width;
  final Color backgroundColor;
  final Widget widget;

  const CustomElevatedButton({
    super.key,
    required this.onTab,
    this.text = '',
    this.height = 50,
    this.width = 100,
    this.backgroundColor = AppColors.primary,
    this.widget = const Text('Button', style: AppTextStyles.buttonText,),
  });

  @override
  Widget build(BuildContext context) {
    return Container (
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height/2),
        boxShadow: [
            BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 2), // changes position of shadow
            ),
          ],
      ),
      child: ElevatedButton(
        child: widget,
        onPressed: onTab, 
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          minimumSize: Size(width, height),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(height/2)
          ),
        ),
      ),
    );
  }
  
}