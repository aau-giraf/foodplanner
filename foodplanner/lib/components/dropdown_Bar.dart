import 'package:flutter/material.dart';
import 'package:foodplanner/config/colors.dart';

class DropdownBar extends StatelessWidget {
  final String? selectedValue;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final Color color;

  const DropdownBar(
      {super.key,
      required this.items,
      this.selectedValue,
      required this.onChanged,
      this.color = AppColors.textFieldBackground // default color
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.transparent, width: 0)),
      child: DropdownMenu<String>(
        width: double.infinity,
        initialSelection: items.first,
        onSelected: (String? value) {
          onChanged(value);
        },
        dropdownMenuEntries:
            items.map<DropdownMenuEntry<String>>((String value) {
          return DropdownMenuEntry<String>(value: value, label: value);
        }).toList(),
      ),
    );
  }
}
