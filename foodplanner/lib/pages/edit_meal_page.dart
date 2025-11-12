import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/image.dart';
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

  final FocusNode _nameFocusNode = FocusNode();
  bool _isSaving = false;

 

  @override
  void initState() {
    super.initState();
    final meal = context.read<MealNotifier>().meal;
    _nameController.text = meal?.name.isNotEmpty == true ? meal!.name : 'madpakke';



    _nameFocusNode.addListener(() {
      if (!_nameFocusNode.hasFocus) {
        _saveTextFieldName(); 
      }
    });
  }

  
  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
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

  if (selected == null) return; // user cancelled

    setState(() {
      _isSaving = true;
    });

    try {
      final uploadResponse = await uploadFoodImage(selected);
      if (uploadResponse.statusCode == 200) {
        final int newImageId = int.tryParse(uploadResponse.body) ?? jsonDecode(uploadResponse.body) as int;

        final Meal updatedMeal = Meal(
          id: currentMeal.id,
          name: _nameController.text.trim().isNotEmpty
              ? _nameController.text.trim()
              : (currentMeal.name.isNotEmpty ? currentMeal.name : 'madpakke'),
          foodImageId: newImageId,
          date: currentMeal.date,
          ingredients: currentMeal.ingredients,
        );

        await updateMeal(http.Client(), context.read(), updatedMeal);
        await mealNotifier.fetchMealData();
      }
    } catch (e) {
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kunne ikke opdatere billedet.')),
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

/*
  Future<void> _fetchIngrediens() async{

      final mealNotifier = context.read<MealNotifier>();
    final currentMeal = mealNotifier.meal;
    


  }*/

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

   Future<void> _updateIngredients(List<Map<String, dynamic>> selectedIngredients) async {
     try {
       final mealNotifier = context.read<MealNotifier>();
       final currentMeal = mealNotifier.meal;
       if (currentMeal == null) return;

       setState(() {
         _isSaving = true;
       });

       // current ingredient IDs ingredients already in the meal)
       final Set<int> currentIds = currentMeal.ingredients
           .map((packed) => packed.ingredient.id)
           .toSet();

       //selected ingredient IDs, the new ingredients 
       final Set<int> selectedIds = selectedIngredients
           .map((ingredient) => ingredient['id'] as int)
           .toSet();

       // Delete ingredients that no longer selected
       for (final packed in currentMeal.ingredients) {
         if (!selectedIds.contains(packed.ingredient.id)) {
           await deletePackedIngredient(context.read(), packed.id);
         }
       }

       // Add new selected ingredients to the meal 
       for (final ingredient in selectedIngredients) {
         final ingredientId = ingredient['id'] as int;
         if (!currentIds.contains(ingredientId)) {
           await createPackedIngredient(context.read(), currentMeal.id, ingredientId);
         }
       }

       // Refresh to show the updated ingredients
       await mealNotifier.fetchMealData();

       if (mounted) {
        // These popup's need a better design for later
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('Ingredienser opdateret!')),
         );
       }
     } catch (e) {
       if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('Kunne ikke opdatere ingredienser.')),
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
              Navigator.pop(context);
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
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                                : FoodImage(foodImageId: meal.foodImageId),
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
                Text('Madpakkens Navn', style: AppTextStyles.headline4, ),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  focusNode: _nameFocusNode ,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Madpakkens nye navn...',
  
                    suffixIcon: Icon(Icons.edit)
                  ),


                ),
                const SizedBox(height: 20),
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Text('Ingredienser', style: AppTextStyles.headline4,),
                   TextButton.icon(
                     onPressed: () async {
                       final meal = context.read<MealNotifier>().meal;
                       final preSelected = meal == null
                           ? <Map<String, dynamic>>[]
                           : meal.ingredients
                               .map((p) => {
                                     'id': p.ingredient.id,
                                     'name': p.ingredient.name,
                                   })
                               .toList();

                       final result = await Navigator.push(
                         context,
                         MaterialPageRoute(
                           builder: (_) => AddIngredientPage(
                             preSelectedIngredients: preSelected,
                           ),
                         ),
                       );

                       if (result != null) {
                         await _updateIngredients(result as List<Map<String, dynamic>>);
                       }
                     },
                     icon: const Icon(Icons.edit_note_sharp),
                     label: const Text('Redigér', ),
                   ),
                 ],
               ),
               const SizedBox(height: 8),
               if (meal == null)
                 const Text('Ingen ingrediens data for denne dato.')
                
               else if (meal.ingredients.isEmpty) 
                 const Text('Ingen ingredienser for denne dato.')
               else 
                
                 ListView.separated(
                   shrinkWrap: true,
                   itemCount: meal.ingredients.length,
                   separatorBuilder: (_, __) => const Divider(height: 0),
                   itemBuilder: (context, index) {
                     final packed = meal.ingredients[index];
                     return ListTile(
                       contentPadding: EdgeInsets.zero,
                       iconColor: Colors.green,
                       leading: const Icon(Icons.check_circle_outline_outlined),
                       title: Text(packed.ingredient.name),
                     );
                   },
                 )


              ],
            ),
          );
        },
      ),
    );
  }
}
