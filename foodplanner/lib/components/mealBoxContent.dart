import 'package:flutter/material.dart';
import 'package:foodplanner/components/image.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/pages/landing_page_children_se_madpakke.dart'; // Update with the correct import
import 'package:foodplanner/components/dateTimePicker.dart';

class Mealboxcontent extends StatelessWidget {
  final Size size;
  final String caption;

  const Mealboxcontent({
  Key? key, 
  required this.size, 
  this.caption = 'Madpakke Text'}) : 
  super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: size.height * 0.02),
        Text(
          caption,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: size.height * 0.02),
        Column(
          children: [
            Container(
              width: size.width * 0.6,
              height: size.width * 0.6, // 40% of the screen height
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FoodImage(foodImageId: 1),
                // child: Image.network(
                //   imageUrl, 
                //   fit: BoxFit.cover,
                //   width: double.infinity,
                //   height: double.infinity,
                //   errorBuilder: (context, error, stackTrace) {
                //     return const Center(child: Text('Image not available'));
                //   },
                //   loadingBuilder: (context, child, loadingProgress) {
                //     if (loadingProgress == null) return child;
                //     return const Center(child: CircularProgressIndicator());
                //   },
                
              ),
            ),
          ],
        ),
      ],
    );
  }
}