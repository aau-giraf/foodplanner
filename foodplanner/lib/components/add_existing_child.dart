
import 'package:flutter/material.dart';
import 'package:foodplanner/components/text_field.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';

class AddExistingChild extends StatelessWidget{
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;

  const AddExistingChild({
    super.key,
    required this.controller,
    this.hintText = 'Engangskode...',
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
          children: [
            SizedBox(height: 10),
            Text(
              'Tilføj barn via engangskode',
              style: AppTextStyles.title,
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              color: AppColors.background,
              surfaceTintColor: AppColors.background,
              elevation: 3,
              margin: EdgeInsets.all(15),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomTextField(
                      controller: controller,
                      errorText: '',
                      hintText: 'Engangskode...',
                      onChanged: onChanged,
                    ),
                  ),
                  SizedBox(height: 15),
                ],
            ),
            ),
          ],
        );
  }
}


