import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodplanner/components/ingredient.dart';
import 'package:foodplanner/components/meal.dart';
import 'package:foodplanner/components/packed_ingredient.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:go_router/go_router.dart';

/// This class is used for selecting which ingredients should be added to the meal.
class AddIngredientPage extends StatelessWidget {
  final int mealID; // The identifier of the meal which the ingredient should be added to.

  const AddIngredientPage({
    super.key,
    required this.mealID,
  });

  static const String routeName = '/add_ingredient_page';

  @override
  Widget build(BuildContext context) {
    final meal = fetchMeal(mealID);
    final List<Ingredient> ingredients = [];
    // final List<Ingredient> ingredients = fetchIngredients() ;

    // List<Ingredient> ingredients = <Ingredient>[ // This list contains all the available ingredients.
    //   Ingredient(name: 'Knækbrød'),       /// TEST ///
    //   Ingredient(name: 'ost:brie'),       /// TEST ///
    //   Ingredient(name: 'ost:mozeralla'),  /// TEST ///
    //   Ingredient(name: 'æble'),           /// TEST ///
    //   Ingredient(name: 'banan'),          /// TEST ///
    // ];
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
          // The search field for the user to search for specific ingredients.
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

          // The list of available ingredients.
          Expanded(
            child: ListView.separated(
              itemCount: ingredients.length, // Creates an element for each item in the ingredients list.
              itemBuilder: (BuildContext context, int index) {
                return TextButton(
                  onPressed: () {
                    if(ingredients[index].image == null) { // Chekcs if the ingredient has an image.
                      showCupertinoDialog( // If not, it opens a pop-up window.
                        context: context, 
                        builder: (BuildContext context) => CupertinoAlertDialog(
                          title: Text('Der er ikke et billede til denne ingrediens, tilføj dette nu.'),
                          actions: <CupertinoDialogAction>[
                            CupertinoDialogAction(
                              isDefaultAction: true,
                              onPressed: () { // Leads the user to the camera page.
                                context.go(CAMERA_PAGE); 
                              },
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