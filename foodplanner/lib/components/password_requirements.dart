import 'package:flutter/material.dart';
import 'package:foodplanner/config/text_styles.dart';

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
        _buildRequirementText(
          'Adgangskoden skal indeholde mindst et stort bogstav.',
          validationStatus['hasUpperCase']!,
        ),
        _buildRequirementText(
          'Adgangskoden skal indeholde mindst et lille bogstav.',
          validationStatus['hasLowerCase']!,
        ),
        _buildRequirementText(
          'Adgangskoden skal indeholde mindst et tal.',
          validationStatus['hasDigit']!,
        ),
        _buildRequirementText(
          'Adgangskoden skal være mindst otte tegn lang.',
          validationStatus['hasMinLength']!,
        ),
        _buildRequirementText(
          'Adgangskoden skal være højst 30 tegn lang.',
          validationStatus['hasMaxLength']!,
        ),
      ],
    );
  }

  // Helper method returning a 'Text'-widget with a color based on whether the requirement is met or not
  Widget _buildRequirementText(String message, bool isMet){
    return Text(
      message,
      style : isMet ? AppTextStyles.successText : AppTextStyles.errorText // determining style, both defined in text_styles.dart
    );
  }
}