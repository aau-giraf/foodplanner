import 'package:flutter/material.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/pages/landing_page_children_se_madpakke.dart'; // Update with the correct import

class ReusableMealBox extends StatelessWidget {
  final Size size;

  const ReusableMealBox({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
            child: Image.network(
              'https://cdn-icons-png.flaticon.com/512/739/739249.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Text('Image not available'));
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ),
        SizedBox(height: size.height * 0.05),
        Center(
          child: SizedBox(
            width: size.width * 0.6, // Set the desired width
            height: 50, // Set the desired height
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChildLandingPageSeMadpakke()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shadowColor: Colors.black, // Set the shadow color to black
                elevation: 5, // Set the elevation to create a shadow effect
              ),
              child: const Text('Se madpakke', style: AppTextStyles.buttonText),
            ),
          ),
        ),
      ],
    );
  }
}