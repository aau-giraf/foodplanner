import 'package:flutter/material.dart';

class MealBoxEmpty extends StatelessWidget {
  final Size size;
  const MealBoxEmpty({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    // Get the size of the screen
    final size = MediaQuery.of(context).size;

    // sabrina carpenter tho :flushedEmoj:
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: size.height * 0.02),
        const Text(
          'ingen madpakke at vise',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
