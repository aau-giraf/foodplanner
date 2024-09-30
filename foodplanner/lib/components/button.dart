import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function()? onTab;

  const CustomButton({super.key, required this.onTab});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTab,
      child: Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.symmetric(horizontal: 150),
        decoration: BoxDecoration(
          color: Color(0xffF9A825),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            'Login',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 26),
          ),
        ),
      ),
    );
  }
}
