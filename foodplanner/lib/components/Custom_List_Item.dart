import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';

class CustomListItem extends StatefulWidget {
  final IconData? leftIcon;
  final TextStyle? leftIconStyle;
  final String title;
  final bool isHighlighted;
  final bool isLastItem;
  final VoidCallback onTap;

  const CustomListItem({
    Key? key,
    this.leftIcon,
    this.leftIconStyle,
    required this.title,
    required this.isHighlighted,
    required this.isLastItem,
    required this.onTap,
  }) : super(key: key);

  @override
  _CustomListItemState createState() => _CustomListItemState();
}

class _CustomListItemState extends State<CustomListItem> {
  bool isTapped = false;

  void toggleIcon() {
    setState(() {
      isTapped = !isTapped;
    });
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: InkWell(
        onTap: toggleIcon,
        child: Column(
          children: [
            Row(
              children: [
                if (widget.leftIcon != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6.0, vertical: 6.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Container(
                        color: AppColors.primary,
                        width: 40,
                        height: 40,
                        child: Center(
                          child: SFIcon(
                            widget.leftIcon!,
                            fontSize: widget.leftIconStyle?.fontSize ?? 25,
                            color: widget.leftIconStyle?.color ??
                                AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  child: Text(
                    widget.title,
                    style: AppTextStyles.bigText.copyWith(
                      fontWeight: widget.isHighlighted
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: widget.isHighlighted ? Colors.blue : Colors.black,
                    ),
                    softWrap: true,
                  ),
                ),
                Icon(
                  isTapped
                      ? SFIcons.sf_chevron_down
                      : SFIcons.sf_chevron_forward,
                ),
                SizedBox(width: 10),
              ],
            ),
            if (!widget.isLastItem)
              Padding(
                padding: const EdgeInsets.only(left: 50),
                child: Container(
                  margin: const EdgeInsets.only(top: 6.0),
                  height: 1.0,
                  color: Colors.grey,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
