import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodplanner/components/ingredient.dart';
import 'package:foodplanner/components/meal.dart';
import 'package:foodplanner/components/packed_ingredient.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';

class AddIngredientPage extends StatelessWidget {
  final Meal meal;

  const AddIngredientPage({
    super.key,
    required this.meal,
  });

  @override
  Widget build(BuildContext context) {
    List<Ingredient> ingredients = <Ingredient>[
      Ingredient(name: 'Knækbrød'),
      Ingredient(name: 'ost:brie'),
      Ingredient(name: 'ost:mozeralla'),
      Ingredient(name: 'æble'),
      Ingredient(name: 'banan'),
    ];
    PackedIngredient new_ingredient = PackedIngredient();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Find madvare"),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 1.0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 5, right: 16, left: 16),
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Skriv her...',
                hintStyle: TextStyle(
                  color: AppColors.textFieldHint,
                ),
                filled: true,
                fillColor: AppColors.textFieldBackground,
              ),
            ),
          ),
          

          Divider(color: AppColors.textFieldBorder,),
          Expanded(
            child: ListView.separated(
              itemCount: ingredients.length,
              itemBuilder: (BuildContext context, int index) {
                return TextButton(
                  onPressed: () {
                    if(ingredients[index].image == null) {
                      showCupertinoDialog(
                        context: context, 
                        builder: (BuildContext context) => CupertinoAlertDialog(
                          title: Text('Der er ikke et billede til denne ingrediens, tilføj dette nu.'),
                          actions: <CupertinoDialogAction>[
                            CupertinoDialogAction(
                              isDefaultAction: true,
                              onPressed: () {},
                              child: const Text("OK"),
                            ),
                          ],
                        )
                      );
                    }
                    
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    )
                  ), 
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(ingredients[index].name, style: AppTextStyles.standard),
                  )
                );
              }, 
              separatorBuilder: (BuildContext context, int index) {
                return Divider(color: AppColors.textFieldBorder,);
              },
            )
          ),
          Divider(color: AppColors.textFieldBorder,),
        ],
      ),
    );
  }
}