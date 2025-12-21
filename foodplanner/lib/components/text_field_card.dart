
import 'package:flutter/material.dart';
import 'package:foodplanner/components/card_container.dart';
import 'package:foodplanner/components/text_field.dart';

// New class for text fields with rounded corners to match new styling
class TextFieldCard extends StatelessWidget{
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String hintText;
  final String errorText;

  const TextFieldCard({
    super.key,
    required this.controller,
    this.onChanged,
    this.hintText = "", //empty by default
    this.errorText = "", //empty by default
  });

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: CustomTextField(
          controller: controller,
          errorText: errorText,
          hintText: hintText,
          onChanged: onChanged,
          color: Colors.white,
        ),
      ),
    );
  }
}

