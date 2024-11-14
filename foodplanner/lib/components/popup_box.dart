import 'package:flutter/material.dart';
import 'package:foodplanner/config/text_styles.dart';

class IPhonePopupBox extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  IPhonePopupBox({
    required this.title,
    this.message = '',
    required this.confirmText,
    required this.cancelText,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: Center(
        child: Text(
          title,
          style: AppTextStyles.headline3,
          textAlign: TextAlign.center,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (message.isNotEmpty)
            Text(message, style: AppTextStyles.mediumText),
          Divider(
            color: Colors.black,
            thickness: 0.25,
          ),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: onCancel,
              child: Text(
                cancelText,
                style: AppTextStyles.errorText,
              ),
            ),
            SizedBox(
              height: 25,
              child: VerticalDivider(
                color: const Color.fromARGB(255, 159, 159, 159),
                thickness: 0.25,
              ),
            ),
            TextButton(
              onPressed: onConfirm,
              child: Text(
                confirmText,
                style: AppTextStyles.errorText.copyWith(
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

void showIPhonePopupBox({
  required BuildContext context,
  required String title,
  String message = '',
  required String confirmText,
  required String cancelText,
  required VoidCallback onConfirm,
  required VoidCallback onCancel,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return IPhonePopupBox(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
      );
    },
  );
}
