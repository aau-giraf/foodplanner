import 'package:flutter/material.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/pages/create_meal_page.dart';

class AddMealButton extends StatelessWidget {
  final Size size;

  const AddMealButton({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size.width * 0.6,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateMealPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shadowColor: Colors.black,
            elevation: 5,
          ),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}