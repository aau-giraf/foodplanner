import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/image.dart';
import 'package:foodplanner/components/settings_widget.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/models/meal.dart';
import 'package:foodplanner/pages/camera_page.dart';
import 'package:foodplanner/services/food_image_service.dart';
import 'package:foodplanner/services/meal_notifier.dart';
import 'package:foodplanner/services/meal_services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
/* import 'package:go_router/go_router.dart';
import 'package:foodplanner/routes/paths.dart'; */
import 'package:foodplanner/pages/add_ingredient_page.dart';
import 'package:foodplanner/services/packed_ingredient_services.dart';

class EditMealPage extends StatefulWidget {
  const EditMealPage({super.key});

  @override
  State<EditMealPage> createState() => _EditMealPageState();
}

class _EditMealPageState extends State<EditMealPage> {
  final TextEditingController _nameController = TextEditingController();

  XFile? _tempImgFile;
  List<Map<String, dynamic>>? _tempIng;
  bool _isSaving = false;
  bool isTemplate = false;

 

  @override
  void initState() {
    super.initState();
    final meal = context.read<MealNotifier>().meal;
    _nameController.text = meal?.name.isNotEmpty == true ? meal!.name : 'madpakke';



  
  }

  
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }



  Future<void> _replaceImage() async {
    final mealNotifier = context.read<MealNotifier>();
    final currentMeal = mealNotifier.meal;
    if (currentMeal == null) return;

   
    final XFile? selected = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CameraPage()),
    );



    if (selected == null) return;

    setState(() {
      _tempImgFile = selected;
    });
  }



   Future<void> _saveTextFieldName() async{
     try {
       final mealNotifier = context.read<MealNotifier>();
       final currentMeal = mealNotifier.meal;
       if (currentMeal == null) return;

        
       final updatedMeal = Meal(
         id: currentMeal.id,
         name: _nameController.text.trim().isNotEmpty
             ? _nameController.text.trim()
             : (currentMeal.name.isNotEmpty ? currentMeal.name : 'madpakke'),
         foodImageId: currentMeal.foodImageId,
         date: currentMeal.date,
         ingredients: currentMeal.ingredients,
       );

       await updateMeal(http.Client(), context.read(), updatedMeal);
       await mealNotifier.fetchMealData();
     } catch (e) {
       if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('Kunne ikke gemme navnet.')),
         );
       }
     }
   }




  void _updateIngredients(List<Map<String, dynamic>> selectedIngredients) {

    // Just update the temporary ingredients list
    setState(() {
      _tempIng = selectedIngredients;
    });
  }

  Future<void> _persistIngUpdate(Meal currentMeal) async {
    if (_tempIng == null) return;

    final Set<int> currentIds = currentMeal.ingredients.map((packed) => packed.ingredient.id).toSet();
    final Set<int> selectedIds = _tempIng!.map((ingredient) => ingredient['id'] as int).toSet();

      // removeing unselected ingredients
    for (final packed in currentMeal.ingredients) {
      if (!selectedIds.contains(packed.ingredient.id)) {
        await deletePackedIngredient(context.read(), packed.id);
      }
    }

    // adding new selected ingredients
    for (final ingredient in _tempIng!) {
      final ingredientId = ingredient['id'] as int;
      if (!currentIds.contains(ingredientId)) {
        await createPackedIngredient(context.read(), currentMeal.id, ingredientId);
      }
    }
  }


    // saving every field 
   Future<void> _saveEverything() async {
    final mealNotifier = context.read<MealNotifier>();
    final currentMeal = mealNotifier.meal;
    if (currentMeal == null) return;

    setState(() {
      _isSaving = true;
    });

    try {
      int updatedFoodImageId = currentMeal.foodImageId as int;
      if (_tempImgFile != null) {
        final uploadResponse = await uploadFoodImage(_tempImgFile!);
        
        if (uploadResponse.statusCode != 200) {
          throw Exception('Image upload could not be ulloaed ${uploadResponse.statusCode}');
        }
      
        updatedFoodImageId = int.tryParse(uploadResponse.body) ?? jsonDecode(uploadResponse.body) as int;
      }

      await _persistIngUpdate(currentMeal);

      final updatedMeal = Meal(
        id: currentMeal.id,
        name: _nameController.text.trim().isNotEmpty
            ? _nameController.text.trim()
            : (currentMeal.name.isNotEmpty ? currentMeal.name : 'madpakke'),
        foodImageId: updatedFoodImageId,
        date: currentMeal.date,
        ingredients: currentMeal.ingredients,
      );

      await updateMeal(http.Client(), context.read(), updatedMeal);
      await mealNotifier.fetchMealData();

      if (mounted) {
        setState(() {
          _tempImgFile = null;
          _tempIng = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ændringer gemt!'), backgroundColor: Colors.green, ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kunne ikke gemme ændringerne.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
   }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: InkWell(
            onTap: () {
              //GoRouter.of(context).go(PARENT_ROOT);
 showCupertinoDialog(
              context: context,
              builder: (BuildContext context) => CupertinoAlertDialog(
                title: const Text('Er du sikker på at du vil gemme ændringerne?'),
                actions: <CupertinoDialogAction>[
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: () async {
                      await _saveEverything();
                    
                     Navigator.pop(context); 
                     Navigator.pop(context); 
                  
                      
                     
                    },
                    child: const Text('Ja'),
                  ),
                  CupertinoDialogAction(
                    isDestructiveAction: true,
                    onPressed: () {
                   
                      Navigator.pop(context);
                      Navigator.pop(context);
                    
                    },
                    child: const Text('Nej'),
                  ),
                ],
              ));
       

           
            },
            child: Row(
              children: [
                SFIcon(SFIcons.sf_chevron_backward),
                const SizedBox(width: 10),
                Text('Tilbage', style: AppTextStyles.headline4),
              ],
            ),
          ),
        ),
        leadingWidth: 200,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Consumer<MealNotifier>(
        builder: (context, mealNotifier, _) {
          final meal = mealNotifier.meal;
          // Retrieve displayed ingredients either from temp or from meal
          final List<Map<String, dynamic>> displayedIngredients = _tempIng ??
              (meal == null
                  ? <Map<String, dynamic>>[]
                  : meal.ingredients
                      .map((p) => {
                            'id': p.ingredient.id,
                            'name': p.ingredient.name,
                            'foodImageId': p.ingredient.foodImageId,
                          })
                      .toList());
          final bool showNoMealData = meal == null && _tempIng == null;


          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Text( 'Redigér Madpakke', style: AppTextStyles.headline2,),
                const SizedBox(height: 20),
                Card(
                  elevation: 2,
                    color: AppColors.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Center(
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showCupertinoDialog(
                                    context: context,
                                    builder: (BuildContext context) => CupertinoAlertDialog(
                                      title: const Text('Vil du tilføje et billede af madpakken?'),
                                      actions: <CupertinoDialogAction>[
                                        CupertinoDialogAction(
                                          isDefaultAction: true,
                                          onPressed: () async {
                                           Navigator.pop(context);
                                            await _replaceImage();
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
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: SizedBox(
                                    width: 220,
                                    height: 220,
                                    child: meal == null
                                        ? Container(color: AppColors.secondary)
                                        : _tempImgFile != null
                                            ? Image.network(_tempImgFile!.path,fit: BoxFit.cover,) // use new image
                                            : FoodImage(foodImageId: meal.foodImageId), //use  existing image
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 8,
                                bottom: 8,
                                child: HeroMode(
                                  enabled: false,
                                  child: FloatingActionButton(
                                    mini: true,
                                    backgroundColor: AppColors.primary,
                                    onPressed: _isSaving ? null : _replaceImage,
                                    child: _isSaving
                                        ? const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                          )
                                        : SFIcon(SFIcons.sf_pencil),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Center(child: Text('Madpakkens Navn', style: AppTextStyles.headline4,  )),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _nameController,
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Madpakkens nye navn...',
                      
                            suffixIcon: Icon(Icons.edit)
                          ),
                    
                    
                        ),
                        const SizedBox(height: 20),
                        Center(child: Text('Ingredienser', style: AppTextStyles.headline4,)),
                    
                       const SizedBox(height: 8),
                       if (showNoMealData)
                         const Text('Ingen ingrediens data for  .')
                       else if (displayedIngredients.isEmpty)
                         const Text('Ingen ingredienser for denne dato.')
                       else 
                         ListView.separated(
                           shrinkWrap: true,
                           itemCount: displayedIngredients.length,
                          separatorBuilder: (_, __) => const Divider(height: 0),
                           itemBuilder: (context, index)  {
                             final ingredient = displayedIngredients[index];
                             
                            return  Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          FoodImage(
            foodImageId: ingredient['foodImageId'],
            width: 50,
            height: 50,
            borderRadius: 8.0,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(ingredient['name']),
          ),
        ],
      ),
    );
    
                           },
                         ),

 const SizedBox(height: 10),
                        CustomButton(onTab:   () async{
                         final meal = context.read<MealNotifier>().meal;
                               final preSelected = _tempIng ??
                                   (meal == null
                                       ? <Map<String, dynamic>>[]
                                       : meal.ingredients
                                           .map((p) => {
                                                 'id': p.ingredient.id,
                                                 'name': p.ingredient.name,
                                               })
                                           .toList());
                         
                               final result = await Navigator.push(
                                 context,
                                 MaterialPageRoute(
                                   builder: (_) => AddIngredientPage(
                                     preSelectedIngredients: preSelected,
                                   )));

                                   
                               if (result != null) {
                                 _updateIngredients(result as List<Map<String, dynamic>>);
                               }
                        }, 
                        text: 'Fjern eller tilføj ingredienser',
                        foregroundColor: AppColors.textPrimary,
                        backgroundColor: Colors.white,
                        trailingIcon: SFIcon(SFIcons.sf_chevron_right),
                        size: ButtonSize.medium
                        
                        ),

                        const SizedBox(height: 20),

  // Skabelon switch
                     Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Gem som skabelon',
                              style: AppTextStyles.headline4,
                            ),
                        
                            CupertinoSwitch(
                              value: isTemplate,
                              onChanged: (value) {
                                setState(() {
                                  isTemplate = value;
                                 
                                });
                              },
                              activeTrackColor: AppColors.primary, 
                            ),]),

                    
                    SizedBox(height: 10,)
                    
                      ]
                      

                      ,
                    ),
                  ),
          
                ),
                const SizedBox(height: 10),
                CustomButton(
                  onTab: () async{
                    if (_isSaving) return;
                  await _saveEverything();
                    Navigator.pop(context);
                  

                 },
                  text: _isSaving ? 'Gemmer...' : 'Gem Ændringer',
                  size: ButtonSize.medium,
                ),
                 const SizedBox(height: 10),
              ],
            ),
          );
        },
    ),
    );
  }
}
