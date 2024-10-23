import 'package:flutter/material.dart';
import 'package:foodplanner/config/colors.dart';

class LunchBox extends StatelessWidget {
  const LunchBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Madpakke side'),
      ),
      backgroundColor: AppColors.background,
      body: const Center(
        child: Text('Madpakke side'),
      ),
    );
  }
}
