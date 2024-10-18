import 'package:flutter/material.dart';
import 'package:foodplanner/components/icon_button.dart';
import 'package:foodplanner/components/ingredient.dart';
import 'package:foodplanner/components/meal.dart';
import 'package:foodplanner/pages/add_ingredient_page.dart';
import 'package:foodplanner/pages/homePage.dart';
import '/pages/cameraPage.dart';

import 'package:foodplanner/config/colors.dart';

/// This class is used to create the meal page where the user can create an individual meal for their children.
class MealPage extends StatefulWidget {
  const MealPage({super.key});

  @override
  _MealPageState createState() => _MealPageState();
}

class _MealPageState extends State<MealPage> {
  final Meal meal = Meal();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  Image? _selectedImage;
  final List<Ingredient> _selectedIngredients = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          // Button for taking the user back to the home page
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
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

      // The button for opening the camera page.
      body: Padding(
          padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, right: 16.0, left: 16.0),
          child: Column(
            children: [
              Text(
                'Start med at tilføje et billede af madpakken', 
                style: TextStyle(color: AppColors.textFieldHint),
              ),
              GestureDetector(
                onTap: () {
                  // When clicked, leads to the camera page.
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CameraPage()),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 170,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey)),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 40,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Textfield for the title of the meal.
              Text(
                'Giv den en titel',
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
                    border: UnderlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // // Textfield for a description and notes for the meal.
              // TextField(
              //   controller: _descriptionController,
              //   keyboardType: TextInputType.multiline,
              //   minLines: 1,
              //   maxLines: 4,
              //   decoration: InputDecoration(
              //     labelText: 'Beskriv måltidet her.',
              //     hintText: 'Skriv her...',
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(12),
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 20),

              // Add Ingredient button
              Text(
                'Beskriv ingredienserne',
                style: TextStyle(color: AppColors.textFieldHint),
              ),
              CustomElevatedButton(
                onTab: () {

                },
                widget: Icon(Icons.add),
                width: MediaQuery.sizeOf(context).width/2,
              ),
              Spacer(),

              // Create meal button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: Size(MediaQuery.sizeOf(context).width/2, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                ),
                child: const Text(
                  'Opret madpakke',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          )),
    );
  }
}
