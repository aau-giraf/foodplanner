import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodplanner/components/image.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/models/meal.dart';

/// This class is used for creating the individual elements for the ingredients.
class EditMealElement extends StatefulWidget {
  final Meal meal; // The ingredient being represented in the UI
  final VoidCallback onCamera; // Callback to pageshift to the camera page

  const EditMealElement({
    super.key,
    required this.meal, // Required parameter to pass an Ingredient object
    required this.onCamera, // Required parameter to shift the page to the camera page
  });

  @override
  _EditMealElement createState() => _EditMealElement();
}

class _EditMealElement extends State<EditMealElement> {
  late TextEditingController _editTitleController; // The TextEditingController making the Ingredient title TextField editable.
  bool _isEditing = false; // Determines whether the the user can edit the TextField.
  int maxTextLength = 20; // The max number of characters that can be written in the TextField.

  @override
  void initState() {
    super.initState();
    _editTitleController = TextEditingController(text: widget.meal.title);
  }

  @override
  void dispose() {
    _editTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width, // Full width of the device screen
      height: 250, // Fixed height for the ingredient element
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24), // Rounded corners for the container
        //border: Border.all(color: Colors.grey),
        color: Color(0xffF2F2F2), // Light grey background color
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Shadow color with partial transparency
            spreadRadius: 1, // Shadow spread radius
            blurRadius: 1, // Shadow blur radius
            offset: const Offset(0, 2), // changes position of shadow (x: 0, y: 2)
          ),
        ],
      ),
      child: Padding(
        // Padding inside the container
        padding: EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 15),
        child: Row(
          children: [
            Spacer(),  // Space between elements
            Column(
              children: [
                Spacer(), // Space at the top of the column
                // The image displaying the ingredient.
                if(widget.meal.imageRef != null) FoodImage(foodImageId: widget.meal.imageRef!),
                // The button for editing the image.
                TextButton(
                  onPressed: () {
                    widget.onCamera(); // Page shifts to the camera page through the "edit_meal_page.dart"
                  },
                  child: Text("Redigér billede"), // Button text for editing 
                ),
                Spacer(), // Space at the bottom of the column
              ],
            ),
            Spacer(), // Space between image column and text column
            Expanded(
              child: Column(
                children: [
                  Spacer(), // Space at the top of this column
                  // The text displaying the title of the ingredient.
                  _isEditing // Checks if _isEditing is true
                    ? TextField( // If yes, 
                      controller: _editTitleController, // The TextEditingController for the textfield.
                      maxLength: maxTextLength, // Limits the max number of charaters that can be inputted in the TextField.
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z +-]")),
                      ], // Only alphanumeric characters can be entered
                      style: AppTextStyles.headline1, // Custom text style for the ingredient name.
                    )
                  : SingleChildScrollView( 
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      widget.meal.title, // Name of the ingredient retrieved from the Ingredient object
                      style: AppTextStyles.headline1,  // Custom text style for the ingredient name
                      overflow: TextOverflow.ellipsis, // Ellipsis for overflowed text
                    ),
                  ),
                  // The button for editing the title of the ingredient.
                  TextButton(
                    onPressed: () {
                      setState(() { // Changes the state of the element when the button is clicked.
                        _isEditing = !_isEditing; // Changes whether the TextField is editable to the opposite.
                      });
                    },
                    child: Text("Redigér tekst"), // Button text for editing title
                  ),
                  Spacer(), // Space at the bottom of this column
                ],
              ),
            ),
            Spacer(),  // Space after the text column
          ],
        ),
      ),
    );
  }
}