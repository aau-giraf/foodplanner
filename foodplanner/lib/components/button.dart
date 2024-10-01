import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function()? onTab;
  final String text;
  final Color MainColor;

  const CustomButton({
    super.key,
    required this.onTab,
    this.text = 'Login', // default text
    this.MainColor = const Color(0xffF9A825), // default color
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTab,
      child: Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.symmetric(horizontal: 150),
        decoration: BoxDecoration(
          color: MainColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 26),
          ),
        ),
      ),
    );
  }
}