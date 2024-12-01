import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/components/icon_button.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/models/ingredient.dart';
import 'package:foodplanner/services/ingredient_services.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

/// This class is used when creating a new ingredient in the system.
class CreateIngredientPage extends StatefulWidget {
  final ValueSetter onCreatedIngredient; // Callback to handle what happens when a new ingredient is created.

  const CreateIngredientPage({
    super.key,
    required this.onCreatedIngredient, // Required callback to handle navigation after a new ingredient is created.
  });

  @override
  _CreateIngredientPageState createState() => _CreateIngredientPageState();
}

/// The state of the page, which contains all the front-end elements,
class _CreateIngredientPageState extends State<CreateIngredientPage> {
  TextEditingController ingredientNameController = TextEditingController(); // The controller for the ingredient name text field.
  final ValueNotifier<bool> isButtonEnabled = ValueNotifier<bool>(false); // Notifier to track the button state.
  Client? client;

  int maxTextLength = 20;

  @override
  void initState() {
    super.initState();
    client = http.Client();
    ingredientNameController.addListener(() {
      isButtonEnabled.value = ingredientNameController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    ingredientNameController.dispose();
    super.dispose();
  }

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
              controller: ingredientNameController, // The textfields assigned controller.
              maxLength: maxTextLength, // Set the maximum length for the input.
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z +-]")),
              ], // Only alphanumeric characters can be entered
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

            ValueListenableBuilder<bool>( 
              valueListenable: isButtonEnabled, // The listener connected to the text editing controller.
              builder: (context, isEnabled, child) {
                return CustomElevatedButton( // The button for creating the new ingredient.
                  onTab: isEnabled // Checks if the controller is empty.
                    ? () { // If the controller is not empty.
                      showCupertinoDialog( // Opens a pop-up for confirming the creation.
                        context: context, 
                        builder: (BuildContext context) => CupertinoAlertDialog( // Create a Cupertino alert dialog.
                          title: Text('Er du sikker på du vil tilføje denne madvare?'), // Title of the dialog.
                          actions: <CupertinoDialogAction>[ // Actions for the alert dialog.
                            CupertinoDialogAction(
                              isDefaultAction: true, // Highlight the default action.
                              onPressed: () async { // Leads the user to the camera page. 
                                Ingredient newIngredient = Ingredient( // The new ingredient.
                                  id: 0,
                                  name: ingredientNameController.text, // The name recieved from the controller.
                                  imageRef: null,
                                );
                                newIngredient = Ingredient.fromJson(jsonDecode((await createIngredient(client!, AuthProvider(), newIngredient.name, newIngredient.imageRef)).body));
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
                    }
                  : null, // If the controller is empty, 
                  width: MediaQuery.sizeOf(context).width/2, // Width of the button is half of the screen width.
                  widget: const Text(
                    'Opret madvare', // Text displayed on the button for creating the meal.
                    style: AppTextStyles.buttonText, // Text style for the button.
                  ),
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}