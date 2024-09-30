import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final controller;
  final dynamic hintText;
  final dynamic obscureText;
  final dynamic color;

  const CustomTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      this.obscureText = false, // default value
      this.color = const Color(0xffF3F8F2) // default color
      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 150),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(10)),
          fillColor: color,
          filled: true,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
