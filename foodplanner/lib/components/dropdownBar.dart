import 'package:flutter/material.dart';
import 'package:foodplanner/config/colors.dart';

class DropdownBar extends StatelessWidget {
  final double width;
  final String? selectedValue;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final Color color;

  const DropdownBar(
      {super.key,
      required this.width,
      required this.items,
      this.selectedValue,
      required this.onChanged,
      this.color = AppColors.textFieldBackground // default color
      });

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      initialSelection: items.first,
      onSelected: (String? value) {
        onChanged(value);
      },
      dropdownMenuEntries: items.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }
}

/* class _DropdownBarState extends State<DropdownBar> {
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
          value: widget.controller.text,
          hint: Text(
            style: AppTextStyles.standard.copyWith(fontSize: 16),
            'Vælg din role',
          ),
          icon: Icon(Icons.arrow_drop_down,
              color: const Color.fromARGB(255, 0, 0, 0)),
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
          onChanged: (String? newValue) {
            widget.onChanged(newValue);
            setState(() {
              widget.controller.text = newValue!;
            });
          },
        ),
      ),
    );
  }
}
 */