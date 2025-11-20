import 'dart:developer' as developer;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/settings_widget.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/pages/add_ingredient_page.dart';
import 'package:foodplanner/pages/camera_page.dart';
import 'package:foodplanner/components/image.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/meal_services.dart';
import 'package:foodplanner/services/packed_ingredient_services.dart';
import 'package:http/http.dart' as http;
import 'package:foodplanner/components/text_field.dart';
import 'package:foodplanner/services/meal_notifier.dart';
import 'package:foodplanner/services/food_image_service.dart';


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
  String baseUrl = ApiConfig.baseUrl;
  int mealId = 0;
  http.MultipartFile? image;

  @override
  void initState() {
    super.initState(); // Call the superclass initState method.
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
    if (mealNameController.text.isEmpty) {
      return 'Madpakke';
    } else {
      return mealNameController.text;
    }
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

  Future<void> createMealWithIngredients() async {
    final selectedIngredientsIds = retrieveSelectedIngredients();
    final mealTitle = retrieveMealName();
    final authProvider =
        AuthProvider(); // Ensure you have an instance of AuthProvider

    final response = await createMeal(
      authProvider,
      mealTitle,
      foodImageId,
      date,
    );

    final Map<String, dynamic> responseData = jsonDecode(response.body);

    if (responseData.containsKey('id')) {
      if (selectedIngredientsIds.isNotEmpty) {
        for (var ingredientId in selectedIngredientsIds) {
          try {
            await createPackedIngredient(
              authProvider,
              responseData['id'],
              ingredientId,
            );
          } catch (e) {
           developer.log(
                'Failed to create packed ingredient for ID: $ingredientId - $e');
          }
        }
      }
    }
  }

  @override
  void dispose() {
    mealNameController.dispose(); // Dispose of the controller.
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
      body: SingleChildScrollView(
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
                color: AppColors.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text('Navn på madpakke',
                          style: AppTextStyles.headline3),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CustomTextField(
                        controller: mealNameController,
                        errorText: "",
                        hintText: 'Navn fx. "Rugbrød med ost og grønt"',
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 50), // Spacer for vertical layout.

                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: selectedIngredients.length,
                        itemBuilder: (BuildContext context, index) {
                          final ingredient = selectedIngredients[index];
                          return SettingsWidget(
                            /*leftWidget: FoodImage(
                              foodImageId: ingredient['foodImageId'],
                              width: 50,
                              height: 50,
                              borderRadius: 8.0,
                            ),*/
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
                              builder: (context) => AddIngredientPage(
                                authProvider: AuthProvider(),
                                preSelectedIngredients: selectedIngredients,
                              ),
                            ),
                          );
                          if (result != null) {
                            setState(() {
                              if (result is List<Map<String, dynamic>>) {
                                selectedIngredients
                                  ..clear()
                                  ..addAll(result);
                              } else if (result is Map<String, dynamic>) {
                                selectedIngredients
                                  ..clear()
                                  ..add(result);
                              }
                            });
                          }
                        },
                        text: 'Tilføj ingredienser',
                        size: ButtonSize.medium,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: CustomButton(
                onTab: () {
                  showCupertinoDialog(
                    context: context,
                    builder: (BuildContext context) => CupertinoAlertDialog(
                      title: Text(
                          'Vil du tilføje et billede af madpakken?'), // Title of the dialog.
                      actions: <CupertinoDialogAction>[
                        CupertinoDialogAction(
                          isDefaultAction:
                              true, // Highlight the default action.
                          onPressed: () async {
                            final image = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CameraPage(),
                              ),
                            );
                            if (image != null) {
                              final imageResponse = await UploadFoodImage(
                                  image); // Ensure this method is defined.
                              final int responseData =
                                  jsonDecode(imageResponse.body);
                              setState(() {
                                foodImageId = responseData;
                              });
                            }
                            createMealWithIngredients();
                            if (!context.mounted){
                              developer.log('buildcontext was unmounted in $runtimeType');
                              return;
                            }
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: const Text("Ja"), // Button text for "Yes".
                        ),
                        CupertinoDialogAction(
                          isDestructiveAction:
                              true, // Mark as a destructive action.
                          onPressed: () async {
                            await createMealWithIngredients();
                            if (!context.mounted){
                              developer.log('buildcontext was unmounted in $runtimeType');
                              return;
                            }
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: const Text('Nej'), // Button text for "No".
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
    );
  }
}
