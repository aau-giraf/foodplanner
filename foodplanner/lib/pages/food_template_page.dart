import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/image.dart';
import 'package:foodplanner/components/loading_animation.dart';
import 'package:foodplanner/components/search_field.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/models/ingredient.dart';
import 'package:foodplanner/models/meal.dart';
import 'package:foodplanner/models/packed_ingredient.dart';
import 'package:foodplanner/pages/add_meal_form_page.dart';
import 'package:foodplanner/services/meal_services.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/sub_ingredient_relation_services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class FoodTemplatePage extends StatefulWidget {
  const FoodTemplatePage({super.key});

  @override
  State<FoodTemplatePage> createState() => _FoodTemplatePage();
}

class _FoodTemplatePage extends State<FoodTemplatePage> {
  final TextEditingController _searchController = TextEditingController();
  final http.Client _client = http.Client();


  // used to show giraf animation while data is being fetched
  bool _isLoading = true;
  String? _error; 
  List<Meal> _templates = const [];
  final Set<int> _expandedTemplateIds = <int>{};
  List<int> selectedTemplates = <int>[];

  bool _isEditMode = false;
  
   final subIngredientRelationServices = SubIngredientRelationServices(
    apiUrl: ApiConfig.baseUrl,
  );

  
  final Set<int> _expandedIngredientIds = <int>{};

  // list of sub-ingredient names for each ingredient id
  final Map<int, Future<List<String>>> _ingredientSubIngredientNames =  {};

  @override
  void initState() {
    super.initState();
    _loadTemplates();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _client.close();
    super.dispose();
  }

  Future<void> _loadTemplates() async {

    // Anitmation giraf while data is being fetched
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final authProvider = context.read<AuthProvider>();
      final templates =
          await fetchMealTemplates(authProvider, client: _client);

      if (!mounted) return;

      //Update the list of templates to be displayed
      setState(() {
        _templates = templates;
      });



    } catch (e) {


      if (!mounted) return;
      setState(() {
        _error = 'Kunne ikke loade templates....';
      });
    } finally {


      if (mounted) {
        // SHow data instead of giraf animation
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _toggleExpanded(int templateId) {
    setState(() {
      if (_expandedTemplateIds.contains(templateId)) {
        _expandedTemplateIds.remove(templateId);
      } else {
        _expandedTemplateIds.add(templateId);
      }
    });
  }

  Future<List<String>> _getSubIngredientNames(int ingredientId) {

      
    return _ingredientSubIngredientNames.putIfAbsent(
      ingredientId,
      () async {
        final authProvider = context.read<AuthProvider>();
       
       
      final subIngredientRelations = await subIngredientRelationServices.getSubIngByIngId(authProvider,ingredientId, client: _client);
       
        final List<String> names = [];

    for (final subIngredientRelation in subIngredientRelations){
      names.add(subIngredientRelation.subIngredient!.name);
    }




       

        return names;
      },
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: () {
                setState(() {
                  _isEditMode = !_isEditMode;
                });
              },
              child: Text(
                _isEditMode ? 'Færdig' :
                'Redigér',
                style: AppTextStyles.headline4.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            ),
          ],
        
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Colors.white,
      body: _isLoading
          ? 
                // Loader giraf animation mens dataen fetches
          const Center(
              child: LoadingAnimation(imagePath: 'assets/images/logo.png'),
            )
          : RefreshIndicator(
              onRefresh: _loadTemplates,
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Vælg skabeloner',
                      style: AppTextStyles.headline2,
                      textAlign: TextAlign.center,
                    ),
                  ),
               Card(
                color: AppColors.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                 child: Padding(
                   padding: const EdgeInsets.all(12.0),
                   child: Column(
                     children: [
                                   _searchField(),
                                   const SizedBox(height: 12),
                                   if (_error != null) _customErrorBanner(mes: _error),
                                   if (_templates.isEmpty)
                 _emptyTemplatesState()
                                   else
                  ..._templates.map(_buildTemplateCard),
                                  
                                   
                                   
                                  
                     ],
                   ),
                 ),
               ),   
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomButton(
                   text:  'Brug skabeloner',
                   size: ButtonSize.medium,
                   onTab: ()  async {
                                 
                     try {
                       final List<Ingredient> res = await useTemplatesWithIDs(
                         context.read<AuthProvider>(),
                         selectedTemplates,
                       );
                  
                       
                       final List<Map<String, dynamic>> formattedIngs =
                           res.map((ing) {
                         return {
                           'id': ing.id,
                           'name': ing.name,
                           'foodImageId': ing.foodImageId,
                         };
                       }).toList();
                  
                       
                       
                         Navigator.pop(context, formattedIngs);
                       
                     } catch (e) {

                      developer.log(e.toString());
                       if (!mounted) return;
                  
                  
                       ScaffoldMessenger.of(context).showSnackBar(
                         const SnackBar(
                           content: Text(
                               'Der ipstod en fejl ved hentning af ingredienser fra skabelonerside'),
                         ),
                       );
                     }
                   },
                                     ),
                ),
                       
                ],
              ),
            ),
    );
  }

  Widget _searchField() {
    return SearchField(
            controller: _searchController,
            hintText: 'Søg efter skabeloner',
           /* onChanged: (value){
            
           } */
          );
  }

  Widget _customErrorBanner({String? mes}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              mes ?? 'Der opstod en fejl',
              style: AppTextStyles.buttonTextSmall.copyWith(color: Colors.white),
            ),
          ),
       
          TextButton(
            onPressed: _loadTemplates,
            child: Row(
              children: [
                 Icon(Icons.refresh_outlined,color: Colors.white,),
                const Text('Prøv igen', style: TextStyle(color: Colors.white),),
              ],
            ),
          ),
          
        ],
      ),
    );
  }

  Widget _emptyTemplatesState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
        const Icon(Icons.fastfood_rounded, size: 48, color: Colors.grey),
          const SizedBox(height: 12),
          Text(
            'Ingen skabeloner at vise',
            style: AppTextStyles.mediumText,
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateCard(Meal meal) {
    final bool isExpanded = _expandedTemplateIds.contains(meal.id);
    final bool isSelected = selectedTemplates.contains(meal.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        
      ),
      
      child: Column(
        children: [
          InkWell(
            onTap: () => {_toggleExpanded(meal.id),
           
           if(isSelected){
             selectedTemplates.remove(meal.id)
            } else {
              selectedTemplates.add(meal.id)
            },
            
            },
          borderRadius: BorderRadius.circular(24), //Fjerner container linjer ved tryk
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: !isSelected? Colors.grey.shade400: AppColors.primary,
                 borderRadius: BorderRadius.circular(24),
              ),

              
              child: Row(
                children: [
                
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      meal.name,
                      style: AppTextStyles.bigText.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),


                  !_isEditMode ?
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.white,
                      size: 35,
                  ): 
                  InkWell(
                    onTap: () {
                      setState(()  {
                       updateTemplateStatus(
                          context.read<AuthProvider>(),
                          meal.id,
                          false, // vi sætter madpakkens templatestatus til false
                        );
                      _templates.removeWhere((template) => template.id == meal.id);
                      });
                    },
                    child: Icon(
                     Icons.delete,
                      color: Colors.red,
                       size: 35,
                    ),
                  ),

                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: _buildExpandedContent(meal),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent(Meal meal) {

      int imgId = meal.foodImageId ?? 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          
              Center(
              child: imgId == 0 ?
              
              Icon(
                Icons.image_outlined,
                size: 86,
                color: AppColors.secondary,
              ) : FoodImage(foodImageId: imgId)
              
              
              
            ),
          
          const SizedBox(height: 18),
          Text(
            'Ingredienser',
            style: AppTextStyles.bigText.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // Ingrediensliste

          if (meal.ingredients.isEmpty)
            Text(
              'Ingen ingredienser fundet',style: AppTextStyles.mediumText.copyWith(color: Colors.grey),
            )
          else
            ...meal.ingredients.map((packedIngredient) =>
                  _buildIngredientItem(meal, packedIngredient)
            ),
        ],
      ),
    );
  }


  Widget _buildIngredientItem(Meal meal, PackedIngredient packedIngredient) {
    final int ingredientId = packedIngredient.ingredient.id;

    // Used to display subingredients
    final bool isExpanded = _expandedIngredientIds.contains(ingredientId);
    final int ingImgID = packedIngredient.ingredient.foodImageId ?? 0;
  

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {

              // Toggle back and fourth
              setState(() {
                if (isExpanded) {
                  _expandedIngredientIds.remove(ingredientId);
                } else {
                  _expandedIngredientIds.add(ingredientId);
                }
              });
            },
            borderRadius: BorderRadius.circular(16),
            
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  ingImgID != 0
                      ? FoodImage(
                          foodImageId: ingImgID,
                          width: 40,
                          height: 40,
                        )
                      : Icon(
                          Icons.image_outlined,
                          size: 40,
                          color: AppColors.secondary,
                        ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      packedIngredient.ingredient.name,
                      style: AppTextStyles.mediumText,
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.secondary,
                  ),
                ],
              ),
            ),
          ),

        // display subingredients here
          if (isExpanded)
            FutureBuilder<List<String>>(
              future: _getSubIngredientNames(ingredientId),
              builder: (context, snapshot) {
              
                final subNames = snapshot.data ?? <String>[];

                if (subNames.isEmpty) {
                  return Padding(padding: EdgeInsets.all(10),
                  child: Text('Ingen underingredienser'));
                 
                }

                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                  child: Column(
                    
                    children: [
                      const SizedBox(height: 5),
                      ...subNames.map(
                        (subIng) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.circle,
                                size: 6,
                                color: AppColors.secondary,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  subIng,
                                  style: AppTextStyles.mediumText.copyWith(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}