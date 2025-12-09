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
import 'package:foodplanner/pages/food_template_page.dart';
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
  bool isUploadingImage = false;
  bool saveAsTemplate = false;

  @override
  void initState() {
    super.initState(); // Call the superclass initState method.
    foodImageId = retrieveFoodImageId();
    _initializeDate();
    selectedIngredientsIds = retrieveSelectedIngredients();
  }

  Future<void> _showImageDialog() async {
   
    await showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Vil du tilføje et billede af madpakken?'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () async {
              Navigator.pop(context);
              await _pickAndUploadImage();
            },
            child: const Text('Ja'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Nej'),
          ),
        ],
      ),
    );
    
  }

  Future<void> _pickAndUploadImage() async {
    final image = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CameraPage(),
      ),
    );

    if (image == null) return;

    setState(() {
      isUploadingImage = true;
    });

    try {
      final imageResponse = await uploadFoodImage(image);
      if (imageResponse.statusCode == 200) {
        final int responseData =
            int.tryParse(imageResponse.body) ?? jsonDecode(imageResponse.body);
        setState(() {
          foodImageId = responseData;
        });
      }
    } catch (e) {
      developer.log('Failed to upload image: $e');
    } finally {
      if (mounted) {
        setState(() {
          isUploadingImage = false;
        });
      }
    }
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: CustomButton(
                        onTab: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FoodTemplatePage(),
                            ),
                          );
                        },
                        text: "Brug Skabelon",
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.textPrimary,
                        size: ButtonSize.medium,
                        sfTrailingIcon: SFIcon(SFIcons.sf_chevron_right),
                      ),
                    ),


          // Image 
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical:   10),
                      child: GestureDetector(
                        onTap: _showImageDialog,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: foodImageId == null
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.image,
                                          size: 48,
                                          color: AppColors.textSecondary,
                                        ),
                                        const SizedBox(height: 8),
                                        Text('Tilføj billede',
                                            style: AppTextStyles.mediumText),
                                      ],
                                    )
                                   
                                  : FoodImage(
                                      foodImageId: foodImageId!,
                                    
                                    ),
                            ),


                            // + Icon button
                            Positioned(
                              right: 12,
                              bottom: 12,
                              child: FloatingActionButton(
                                mini: true,
                                backgroundColor: AppColors.primary,
                                onPressed: isUploadingImage
                                    ? null
                                    : _showImageDialog,
                                child: isUploadingImage
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : SFIcon(SFIcons.sf_plus),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                         Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text('Navn på madpakke',
                          style: AppTextStyles.headline4),
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

                    const SizedBox(height: 30),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Ingredienser',
                        style: AppTextStyles.headline4,
                      ),
                    ),



                  
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: selectedIngredients.length,
                        itemBuilder: (BuildContext context, index) {
                        
                          final ingredient = selectedIngredients[index];
                          return SettingsWidget(
                            leftWidget: FoodImage(
                              foodImageId: ingredient['foodImageId'],
                              width: 50,
                              height: 50,
                              borderRadius: 8.0,
                            ),
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
                        text: 'Fjern eller tilføj ingredienser',
                        sfTrailingIcon: SFIcon(SFIcons.sf_chevron_right),
                        size: ButtonSize.medium,
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.textPrimary,
                      ),
                    ),



                    SizedBox(height: 20),

                    // Skabelon switch
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Gem som skabelon',
                                    style: AppTextStyles.headline4),
                                const SizedBox(height: 4),
                                Text('Gem madpakken til senere brug',
                                    style: AppTextStyles.mediumText),
                              ],
                            ),
                        
                            CupertinoSwitch(
                              value: saveAsTemplate,
                              onChanged: (value) {
                                setState(() {
                                  saveAsTemplate = value;
                                });
                              },
                              activeColor: AppColors.primary, // mAYBE  green is better?
                            ),
                          ],
                        ),
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
                onTab: () async {
                  await createMealWithIngredients();
                  Navigator.pop(context);
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
