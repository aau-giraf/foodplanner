import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodplanner/components/image.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/models/meal.dart';

/// This class is used for creating the individual elements for the ingredients.
class EditMealElement extends StatefulWidget {
  final Meal meal; // The ingredient being represented in the UI
  final VoidCallback onCamera; // Callback to pageshift to the camera page
  final TextEditingController
      editTitleController; // The TextEditingController making the Ingredient title TextField editable.

  const EditMealElement({
    super.key,
    required this.meal, // Required parameter to pass an Ingredient object
    required this.onCamera, // Required parameter to shift the page to the camera page
    required this.editTitleController, // The text editing controller for the title.
  });

  @override
  _EditMealElement createState() => _EditMealElement();
}

/// The state of the component which contains the body.
class _EditMealElement extends State<EditMealElement> {
  bool _isEditing =
      false; // Determines whether the the user can edit the TextField.
  int maxTextLength =
      20; // The max number of characters that can be written in the TextField.

  File? image; // The image of the meal.
  Uint8List?
      webImageBytes; // The image of the meal in byte form for web applications.

  @override
  void initState() {
    super.initState();
    // widget.editTitleController = TextEditingController(text: widget.meal.title);
  }

  // This method is used for deleting the text editing controller.
  @override
  void dispose() {
    widget.editTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width:
          MediaQuery.sizeOf(context).width, // Full width of the device screen
      height: 220, // Fixed height for the ingredient element
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(24), // Rounded corners for the container
        //border: Border.all(color: Colors.grey),
        color: Color(0xffF2F2F2), // Light grey background color
        boxShadow: [
          BoxShadow(
            color: Colors.grey
                .withOpacity(0.5), // Shadow color with partial transparency
            spreadRadius: 1, // Shadow spread radius
            blurRadius: 1, // Shadow blur radius
            offset:
                const Offset(0, 2), // changes position of shadow (x: 0, y: 2)
          ),
        ],
      ),
      child: Padding(
        // Padding inside the container
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            if (widget.meal.foodImageId != null)
              Flexible(
                flex: 2,
                child: Column(
                  children: [
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1.0,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 100,
                            maxWidth: 100,
                          ),
                          child: FoodImage(foodImageId: widget.meal.foodImageId!),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: widget.onCamera,
                      child: Text("Redigér billede"),
                    ),
                  ],
                ),
              ),
            SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Spacer(), // Space at the top of this column
                  // The text displaying the title of the ingredient.
                  _isEditing // Checks if _isEditing is true
                      ? Flexible(
                          child: TextField(
                            // If yes,
                            controller: widget
                                .editTitleController, // The TextEditingController for the textfield.
                            maxLength:
                                maxTextLength, // Limits the max number of charaters that can be inputted in the TextField.
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp("[0-9a-zA-Z +-]")),
                            ], // Only alphanumeric characters can be entered
                            style: AppTextStyles
                                .headline2, // Custom text style for the ingredient name.
                            maxLines: 1,
                            decoration: InputDecoration(
                              isDense: true,
                            ),
                          ),
                        )
                      : Flexible(
                          child: Text(
                            widget.editTitleController.text,
                            style: AppTextStyles.headline1,
                          ),
                        ),
                  // The button for editing the title of the ingredient.
                  TextButton(
                    onPressed: () {
                      setState(() {
                        // Changes the state of the element when the button is clicked.
                        _isEditing =
                            !_isEditing; // Changes whether the TextField is editable to the opposite.
                      });
                    },
                    child:
                        Text("Redigér tekst"), // Button text for editing title
                  ),
                  // Spacer(), // Space at the bottom of this column
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
