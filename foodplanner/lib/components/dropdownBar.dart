import 'package:flutter/material.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';

class DropdownBar extends StatefulWidget {
  final double width;
  final String? selectedValue;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final TextEditingController controller;
  final Color color;

  DropdownBar({
    required this.width,
    required this.items,
    this.selectedValue,
    required this.onChanged,
    required this.controller,
    this.color = AppColors.textFieldBackground // default color
  });

  @override
  _DropdownBarState createState() => _DropdownBarState();
}

class _DropdownBarState extends State<DropdownBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)), 
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: widget.selectedValue,
          hint: Text(
            style: AppTextStyles.standard.copyWith(fontSize: 16),
            'Vælg din role',
          ),
          icon: Icon(Icons.arrow_drop_down, color: const Color.fromARGB(255, 0, 0, 0)),
          isExpanded: true,
          items: widget.items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                style: AppTextStyles.standard.copyWith(fontSize: 16),
                value,
              ),
            );
          }).toList(),
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}