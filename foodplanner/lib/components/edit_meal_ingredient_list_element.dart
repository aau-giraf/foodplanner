import 'package:flutter/material.dart';
import 'package:foodplanner/components/ingredient.dart';
import 'package:foodplanner/config/text_styles.dart';

/// This class is used for creating the individual elements for the ingredients.
class EditMealIngredientListElement extends StatelessWidget{
  final Ingredient ingredient;

  const EditMealIngredientListElement({
    super.key,
    required this.ingredient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        //border: Border.all(color: Colors.grey),
        color: Color(0xffF2F2F2),
        boxShadow: [
          BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 1,
          offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 15),
        child: Row(
          children: [
            Spacer(),

            Column(
              children: [
                Spacer(),

                // The image displaying the ingredient.
                // Indsæt image
                Container(height: 150, width: 150, color: Colors.blue, child: Text('Temporary box to show picture size')),

                // The button for editing the image.
                TextButton(
                  onPressed: () {},
                  child: Text("Redigér billede"),
                ),
                Spacer(),
              ],
            ),
            Spacer(),

            Column(
              children: [
                Spacer(),

                // The text displaying the title of the ingredient.
                Text(ingredient.name, style: AppTextStyles.headline1),

                // The button for editing the title of the ingredient.
                TextButton(
                  onPressed: () {},
                  child: Text("Redigér tekst"),
                ),

                Spacer(),
              ],
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}