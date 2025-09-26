import 'package:flutter/material.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/config/colors.dart';

// New class for text indicating whether the requirements for a password is met when creating a user

class PasswordRequirements extends StatelessWidget{
  final Map<String, bool> validationStatus;

  const PasswordRequirements({
    super.key,
    required this.validationStatus, // 'required' ensures that validationStatus is provided
  });

  // Building the widget consisting of the list of requirements
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Adgangskoden skal indeholde:',
          style: AppTextStyles.mediumTextWithoutColor,
        ),
        _buildRequirementText(
          'Mindst ét stort og ét lille bogstav.',
          validationStatus['hasUpperAndLowerCase']!,
        ),
        _buildRequirementText(
          'Mindst et tal.',
          validationStatus['hasDigit']!,
        ),
        _buildRequirementText(
          '8-30 tegn.',
          validationStatus['hasLength']!,
        ),
      ],
    );
  }

  // Helper method returning a 'Row'-widget containing text and icon
  Widget _buildRequirementText(String message, bool isMet){
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isMet ? Icons.check : Icons.clear,
          color: isMet ? Colors.green : AppColors.errorText,
        ),
        Text(
          message,
          style : isMet ? AppTextStyles.requirementTextGreen : AppTextStyles.requirementTextRed // determining style, both defined in text_styles.dart
        ),
      ],
    );
  }
}