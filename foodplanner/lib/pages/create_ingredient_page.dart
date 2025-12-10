import 'dart:developer' as developer;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/image.dart';
import 'package:foodplanner/components/text_field.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/pages/camera_page.dart';
import 'package:foodplanner/services/food_image_service.dart';
import 'package:foodplanner/models/ingredient.dart';
import 'package:foodplanner/models/sub_ingredient.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/ingredient_services.dart';
import 'package:foodplanner/services/sub_ingredient_services.dart';
import 'package:foodplanner/services/sub_ingredient_relation_services.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class CreateIngredientPage extends StatefulWidget {
  const CreateIngredientPage({super.key});

  @override
  State<CreateIngredientPage> createState() => _CreateIngredientPageState();
}

class _CreateIngredientPageState extends State<CreateIngredientPage> {
  TextEditingController ingredientNameController = TextEditingController();
  TextEditingController subIngredientController = TextEditingController();
  final ValueNotifier<bool> isButtonEnabled = ValueNotifier<bool>(false);
  Client? client;
  int? foodImageId;

  bool _isEditMode = false;

  final List<SubIngredient> _subIngredients = [];
  final Set<int> _selectedSubIngredients = {};
 
  bool _isLoadingSubIngredients = false;  

  final ingredientServices = IngredientServices(
    apiUrl: ApiConfig.baseUrl,
  );
  final subIngredientServices = SubIngredientServices(
    apiUrl: ApiConfig.baseUrl,
  );
  final subIngredientRelationServices = SubIngredientRelationServices(
    apiUrl: ApiConfig.baseUrl,
  );
  final authProvider = AuthProvider();

  @override
  void initState() {
    super.initState();
    client = http.Client();
    ingredientNameController.addListener(() {
      isButtonEnabled.value = ingredientNameController.text.isNotEmpty;
    });
    _loadSubIngredients();
  }

  @override
  void dispose() {
    ingredientNameController.dispose();
    subIngredientController.dispose();
    client!.close();
    super.dispose();
  }

  Future<void> _loadSubIngredients() async {
    try {
      final subIngredients = await subIngredientServices.getAllSubIngredientsByUser(
        authProvider,
        client: client,
      );


      setState(() {
        
       _subIngredients.clear();
      _subIngredients.addAll(subIngredients);
          _selectedSubIngredients.clear();

      });
    } catch (e) {
      developer.log(e.toString());
    }
  }

 

  Future<void> createIngredient() async {
    try {
      
      Ingredient newIngredient = Ingredient(name: ingredientNameController.text,
      foodImageId: foodImageId,
      );

      final response = await ingredientServices.createIngredient(client!,authProvider,
       newIngredient.name,
        newIngredient.foodImageId,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(response.statusCode);
      }

      newIngredient = Ingredient.fromJson(
        jsonDecode(response.body),
      );

      // Creating a relation between the ingredient and all of its subingredients
      for (int i = 0; i < _subIngredients.length; i++) {
        if (_selectedSubIngredients.contains(i)) {
          await subIngredientRelationServices.createSubIngredientRelation(
            authProvider,
            newIngredient.id,
            _subIngredients[i].id,
        
          );
        }
      } 


      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ingrediensen er oprettet!'), backgroundColor: Colors.green,),
        );
        Navigator.pop(context, newIngredient);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fejl ved oprettelse af ingrediensen: $e')),
        );
      }
    }
  }

  Future<void> _addSubIngredient() async {

    // removing leading and trailing whitespaces 
    final text = subIngredientController.text.trim();
    if (text.isEmpty){
    ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Underingrediensen kan ikke være tom', style: TextStyle(fontWeight: FontWeight.bold),), backgroundColor: Colors.orange,
          // behavior: SnackBarBehavior.floating,
          
        ));
    
     return;}

    try {
      // Check if sub-ingredient already exists
      SubIngredient? existingSubIngredient;
      try {
        final allSubIngredients =
            await subIngredientServices.getAllSubIngredientsByUser(
          authProvider,
          client: client,
        );
        try {
          existingSubIngredient = allSubIngredients.firstWhere(
            (subIng) => subIng.name.toLowerCase() == text.toLowerCase(),
          );
        } catch (e) {
          
          existingSubIngredient = null;
        }
      } catch (e) {
        existingSubIngredient = null;
        
      }

      SubIngredient subIngredient;
      if (existingSubIngredient != null) {
        subIngredient = existingSubIngredient;
      } else {
        // Create new sub-ingredient
        subIngredient = SubIngredient(name: text);
        final response = await subIngredientServices.createSubIngredient(
          authProvider,
         subIngredient
         ,
        );

        if (response.statusCode != 200 && response.statusCode != 201) {
          throw Exception('Failed to create sub-ingredient');
        }

        subIngredient = SubIngredient.fromJson(
          jsonDecode(response.body),
        );
      }

      setState(() {
        if (!_subIngredients.any((subIng) => subIng.id == subIngredient.id)) {
          _subIngredients.add(subIngredient);
          
        }

         final index =_subIngredients.indexWhere((subIng) => subIng.id == subIngredient.id);
          if (index != -1) {
            _selectedSubIngredients.add(index);
          }
        subIngredientController.clear();
      });

   
    } catch (e) {
      developer.log('Error adding sub-ingredient$e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fejl ved tilføjelse af underingrediens $e'), backgroundColor: Colors.red,),
        );
      }
    }
  }

  void _removeSubIngredient(int index) async {
    final deletingSubIng = _subIngredients.elementAt(index);
    await subIngredientServices.deleteSubIngredient(authProvider, deletingSubIng.id);
    setState(() {
     _subIngredients.removeAt(index);

    
    _selectedSubIngredients.remove(index);
    
    // shifting all indices greater than the deleted index since _selectedSubIngredients was modified
    final adjustedSelectedSubIng = <int>{};
    for (int selectedIndex in _selectedSubIngredients) {
      if (selectedIndex > index) {
        adjustedSelectedSubIng.add(selectedIndex - 1);
      } else {
        adjustedSelectedSubIng.add(selectedIndex);
      }
    }
    _selectedSubIngredients.clear();
    _selectedSubIngredients.addAll(adjustedSelectedSubIng);
    });
  }

  void _toggleSubIngredientSelection(int index) {
    setState(() {
      if (_selectedSubIngredients.contains(index)) {
        _selectedSubIngredients.remove(index);
      } else {
        _selectedSubIngredients.add(index);
      }
    });
  }

  void _showImageDialog() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text(
          'Vil du tilføje et billede af madvaren?',
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () async {
              Navigator.pop(context);
              final image = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CameraPage(),
                ),
              );

           

              if (image != null && mounted) {
                try {
                  final imageResponse = await uploadFoodImage(image);
                  final int responseData = jsonDecode(imageResponse.body);
                  setState(() {
                    foodImageId = responseData;
                  });
                } catch (e) {
    
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Fejl ved uploadelse af billedet'),backgroundColor: Colors.red,),
                    );
                  }
                }
              }
            },
            child: const Text("Ja"),
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
                const SizedBox(width: 10),
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
       
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Text(
                  "Tilføj ingrediens",
                  style: AppTextStyles.headline2,
                ),
              ),
              const SizedBox(height: 20),
              Stack(
                children: [
                  Card(
                    color: AppColors.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: _showImageDialog,
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 100  ,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: FoodImage(foodImageId: foodImageId),
                                    ),
                                    if (foodImageId == null)
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            shape: BoxShape.circle,
                                           
                                          ),
                                          padding: const EdgeInsets.all(8),
                                          child: const Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                 
                                  children: [
                                    Center(
                                      child: Text(
                                        'Ingrediens navn',
                                        style: AppTextStyles.headline3,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    CustomTextField(
                                      controller: ingredientNameController,
                                      errorText: '',
                                      hintText: 'Ingrediens navn...',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Center(
                            child: Text(
                              'Tilføj underingredienser',
                              style: AppTextStyles.headline3,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  controller: subIngredientController,
                                  errorText: '',
                                  hintText: 'Tilføj subingredienser',
                                ),
                              ),
                              const SizedBox(width: 12),
                              GestureDetector(
                                onTap: _addSubIngredient,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),


                          // Scrollable sub-ingredients list
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 400),
                            child: _subIngredients.isEmpty
                                ? Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 30),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.fastfood_rounded, size: 40,),
                                      Text(
                                        'Ingen underingredienser tilføjet',
                                        style: AppTextStyles.mediumText.copyWith(
                                          color: Colors.black,
                                      
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: _subIngredients.length,
                                    itemBuilder: (context, index) {
                                      final isSelected = _selectedSubIngredients.contains(index);
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 8),
                                        child: GestureDetector(
                                          onTap: () {
                                            _toggleSubIngredientSelection(index);
                                          },
                                          child: Container(
                                            height: 60,
                                            decoration: BoxDecoration(
                                              color: isSelected ? AppColors.primary : Colors.white,
                                              borderRadius: BorderRadius.circular(24),
                                              border: Border.all(
                                                color: Colors.grey.shade300,
                                                width: 1,
                                              ),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 12,
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    _subIngredients[index].name,
                                                    style: AppTextStyles.bigText.copyWith(
                                                      color: isSelected ? Colors.white : Colors.black,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                if (_isEditMode)
                                                  GestureDetector(
                                                    onTap: () {
                                                      _removeSubIngredient(index);
                                                    },
                                                    child: const Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                      size: 30,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        
                        ],
                      ),
                    ),
                  ),
                 
                  Positioned(
                        bottom: 0,
                        left: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: SizedBox(
                            width: 100, 
                            height: 30,
                            child: FloatingActionButton(
                              
                              
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor: AppColors.primary,
                              onPressed: () {
                                setState(() => _isEditMode = !_isEditMode);
                              },
                              child: _isEditMode ? Text('Færdig', style: AppTextStyles.buttonTextMedium.copyWith(color: Colors.white),) : Text('Rediger', style: AppTextStyles.buttonTextMedium.copyWith(color: Colors.white),),
                            ),
                          ),
                        ),
                      ),
            
                ],
              ),
              const SizedBox(height: 24),
              ValueListenableBuilder<bool>(
                valueListenable: isButtonEnabled,
                builder: (context, isEnabled, child) {
                  return CustomButton(
                    onTab: isEnabled
                        ? () {
                            createIngredient();
                          }
                        : null,
                    text: 'Opret ingrediens',
                    size: ButtonSize.medium,
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}