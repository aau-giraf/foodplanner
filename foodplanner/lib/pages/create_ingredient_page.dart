import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodplanner/components/icon_button.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/models/ingredient.dart';

class CreateIngredientPage extends StatefulWidget {
  final ValueSetter onCreatedIngredient;

  const CreateIngredientPage({
    super.key,
    required this.onCreatedIngredient,
  });

  @override
  _CreateIngredientPageState createState() => _CreateIngredientPageState();
}

class _CreateIngredientPageState extends State<CreateIngredientPage> {
  TextEditingController ingredientNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 32, right: 16, left: 16),
        child: Column(
          children: [
            Text(
              "Ingrediens",
              style: AppTextStyles.headline2,
            ),
            TextField(
              controller: ingredientNameController,
              decoration: InputDecoration(
                counterText: '', // Hides the character counter.
                border: InputBorder.none, // Removes the default border.
                hintText: 'Skriv her...', // Placeholder text.
                hintStyle: TextStyle(
                  color: AppColors.textFieldHint, // Hint text color.
                ),
                filled: true, // Enables filling the background of the text field.
                fillColor: AppColors.textFieldBackground, // Background color of text field.
              ),
            ),
            
            CustomElevatedButton(
              onTab: () {
                showCupertinoDialog( // If not, it opens a pop-up window.
                  context: context, 
                  builder: (BuildContext context) => CupertinoAlertDialog( // Create a Cupertino alert dialog.
                    title: Text('Er du sikker på du vil tilføje denne madvare?'), // Title of the dialog.
                    actions: <CupertinoDialogAction>[ // Actions for the alert dialog.
                      CupertinoDialogAction(
                        isDefaultAction: true, // Highlight the default action.
                        onPressed: () async { // Leads the user to the camera page. 
                          Ingredient newIngredient = Ingredient(
                            id: 0,
                            name: ingredientNameController.text,
                            imageRef: null,
                          );
                          Navigator.pop(context);
                          widget.onCreatedIngredient(newIngredient); // Calls the camera callback.
                          //context.pop();
                        },
                        child: const Text("Ja"), // Button text for "Yes".
                      ),
                      CupertinoDialogAction(
                        isDestructiveAction: true, // Mark as a destructive action.
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Nej'),  // Button text for "No".
                      ),
                    ],
                  ),
                );
              },
              width: MediaQuery.sizeOf(context).width/2, // Width of the button is half of the screen width.
              widget: const Text(
                'Opret madvare', // Text displayed on the button for creating the meal.
                style: AppTextStyles.buttonText, // Text style for the button.
              ),
            ),
          ],
        ),
      ),
    );
  }
}