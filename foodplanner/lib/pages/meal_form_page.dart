import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodplanner/components/icon_button.dart';
import 'package:foodplanner/components/ingredient.dart';
import 'package:foodplanner/components/meal.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:foodplanner/services/meal_services.dart';
import 'package:go_router/go_router.dart';

import 'package:foodplanner/config/colors.dart';

/// This class is used to create the meal page where the user can create an individual meal for their children.
class MealFormPage extends StatefulWidget {
  final Meal meal;
  final List<Ingredient> ingredients;
  final VoidCallback onAddIngredients;
  final VoidCallback onCamera;
  
  const MealFormPage({
    super.key,
    required this.meal,
    required this.ingredients,
    required this.onAddIngredients,
    required this.onCamera,
  });

  static const String routeName = '/meal_form_page';

  @override
  _MealFormPageState createState() => _MealFormPageState();
}



class _MealFormPageState extends State<MealFormPage> {
  final TextEditingController _titleController = TextEditingController();
  Image? _selectedImage;

  // Method for deleting the controllers when they are done being used.
  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final List<Ingredient> selectedIngredients = [];
    // selectedIngredients.addAll(
    //   widget.ingredients.where((ingredient) {
    //     return widget.meal.getPackedIngredients.map(
    //       (packedIngredient) => packedIngredient.ingredientRef.id).contains(ingredient.id);
    //     }
    //   ),
    // );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Opret madpakke"),
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

      body: Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 16.0, left: 16.0),
        child: Column(
          children: [
            // Textfield for the title of the meal.
            Text(
              'Start med at give madpakken en titel',
              style: TextStyle(color: AppColors.textFieldHint),
            ),
            Container(
              padding: const EdgeInsets.only(left: 50.0, right: 50.0),
              child: TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Skriv her...',
                  hintStyle: TextStyle(
                    color: AppColors.textFieldHint,
                  ),
                  // border: UnderlineInputBorder(),
                ),
              ),
            ),

            const SizedBox(height: 50),

            // Add Ingredient button
            Text(
              'Tilføj ingredienser',
              style: TextStyle(color: AppColors.textFieldHint),
            ),
            CustomElevatedButton(
              onTab: () {
                // context.go(ADD_INGREDIENT_PAGE);
                widget.onAddIngredients();
              },
              widget: Icon(Icons.add, color: AppColors.textSecondary),
              backgroundColor: AppColors.secondary,
              width: MediaQuery.sizeOf(context).width/2,
            ),
            Spacer(),

            // Create meal button
            CustomElevatedButton(
              onTab: () {
                showCupertinoDialog( // If not, it opens a pop-up window.
                  context: context, 
                  builder: (BuildContext context) => CupertinoAlertDialog(
                    title: Text('Vil du tilføje et billede af madpakken?  '),
                    actions: <CupertinoDialogAction>[
                      CupertinoDialogAction(
                        isDefaultAction: true,
                        onPressed: () { // Leads the user to the camera page.
                          // context.go(CAMERA_PAGE); 
                          widget.onCamera();
                        },
                        child: const Text("Ja"),
                      ),
                      CupertinoDialogAction(
                        isDestructiveAction: true,
                        onPressed: () {
                          createMeal(
                            _titleController.text,
                            null,
                            DateTime.now(),
                            widget.meal.getPackedIngredients,
                          );
                          context.go(MEAL_LIST_PAGE);
                        },
                        child: const Text('Nej'),
                      ),
                    ],
                  ),
                );
              },
              width: MediaQuery.sizeOf(context).width/2,
              widget: const Text(
                'Opret madpakke',
                style: AppTextStyles.buttonText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
