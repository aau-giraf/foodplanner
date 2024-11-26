import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/settings_widget.dart';
import 'package:foodplanner/models/ingredient.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/models/packed_ingredient.dart';
import 'package:foodplanner/pages/add_ingredient_page.dart';
import 'package:foodplanner/services/meal_services.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:foodplanner/components/text_field.dart';
import 'package:foodplanner/services/meal_notifier.dart';

/// This class is used to create the meal page where the user can create an individual meal for their children.
class MealFormPage extends StatefulWidget {
  const MealFormPage({
    super.key,
  });

  @override
  _MealFormPageState createState() =>
      _MealFormPageState(); // Create the state for this page.
}

class _MealFormPageState extends State<MealFormPage> {
  final List<Map<String, dynamic>> selectedIngredients = [];
  late String mealTitle;
  int? foodImageId;
  DateTime? date;
  late List<int> selectedIngredientsIds;
  final TextEditingController mealNameController = TextEditingController();

  @override
  void initState() {
    super.initState(); // Call the superclass initState method.
    mealTitle = retrieveMealName();
    foodImageId = retrieveFoodImageId();
    _initializeDate();
    selectedIngredientsIds = retrieveSelectedIngredients();
  }

  Future<void> _initializeDate() async {
    final mealNotifier = MealNotifier();
    date = await mealNotifier.retrieveDate();
    setState(() {});
  }

  // Method for deleting the controllers when they are done being used.
  String retrieveMealName() {
    return mealNameController.text;
  }

  int? retrieveFoodImageId() {
    // Logic to retrieve the food image ID
    return 1;
  }

  List<int> retrieveSelectedIngredients() {
    return selectedIngredients
        .map((ingredient) => ingredient['id'] as int)
        .toList();
  }

  @override
  void dispose() {
    super.dispose(); // Call the superclass dispose method.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Row(
              children: [
                SFIcon(SFIcons.sf_chevron_backward),
                SizedBox(width: 10),
                Text(
                  'Tilbage',
                  style: AppTextStyles.headline4,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ),
        leadingWidth: 200,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: [
            SettingsWidget(
              leftIcon: SFIcons.sf_fork_knife,
              title: 'Opret madpakke',
              subTitle: 'Her kan du oprette en madpakke til dit barn',
              type: SettingsType.header,
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text('Navn på madpakke', style: AppTextStyles.mediumText),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CustomTextField(
                        controller: TextEditingController(),
                        errorText: "",
                        hintText: 'Navn fx. "Rugbrød med ost og grønt"',
                      ),
                    ),

                    const SizedBox(height: 50), // Spacer for vertical layout.

                    SizedBox(
                      height: selectedIngredients.isNotEmpty ? 350 : 0,
                      child: ListView.builder(
                        itemCount: selectedIngredients.length,
                        itemBuilder: (BuildContext context, index) {
                          final ingredient = selectedIngredients[index]
                              as Map<String, dynamic>;
                          return SettingsWidget(
                            leftIcon: SFIcons
                                .sf_person_crop_circle_fill_badge_checkmark,
                            title: ingredient['name'],
                            type: SettingsType.items,
                          );
                        },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CustomButton(
                        onTab: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddIngredientPage(),
                            ),
                          );
                          if (result != null) {
                            setState(() {
                              if (result is List<Map<String, dynamic>>) {
                                selectedIngredients.addAll(result);
                              } else if (result is Map<String, dynamic>) {
                                selectedIngredients.add(result);
                              }
                            });
                          }
                        },
                        text: 'Tilføj ingredienser',
                        size: ButtonSize.medium,
                      ),
                    ),
                    SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 20, left: 20, right: 20),
                      child: CustomButton(
                        onTab: () {
                          showCupertinoDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                CupertinoAlertDialog(
                              title: Text(
                                  'Vil du tilføje et billede af madpakken?'), // Title of the dialog.
                              actions: <CupertinoDialogAction>[
                                CupertinoDialogAction(
                                  isDefaultAction:
                                      true, // Highlight the default action.
                                  onPressed: () {
                                    Navigator.pop(context);
                                    // Add your camera callback here
                                  },
                                  child: const Text(
                                      "Ja"), // Button text for "Yes".
                                ),
                                CupertinoDialogAction(
                                  isDestructiveAction:
                                      true, // Mark as a destructive action.
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    // Add your create meal callback here
                                    final authProvider =
                                        AuthProvider(); // Ensure you have an instance of AuthProvider
                                    final response = await createMeal(
                                      authProvider,
                                      mealTitle,
                                      foodImageId,
                                      date,
                                    );
                                    if (response.statusCode == 200) {
                                      // Handle successful meal creation
                                      print('Meal created successfully');
                                    } else {
                                      // Handle error
                                      print('Failed to create meal');
                                    }
                                  },
                                  child: const Text(
                                      'Nej'), // Button text for "No".
                                ),
                              ],
                            ),
                          );
                        },
                        text: 'Opret madpakke',
                        size: ButtonSize.medium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
