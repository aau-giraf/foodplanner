import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/image.dart';
import 'package:foodplanner/components/loading_animation.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/models/ingredient.dart';
import 'package:foodplanner/models/meal.dart';
import 'package:foodplanner/models/packed_ingredient.dart';
import 'package:foodplanner/pages/add_meal_form_page.dart';
import 'package:foodplanner/services/meal_services.dart';
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

  bool _isLoading = true;
  String? _error;
  List<Meal> _templates = const [];
  final Set<int> _expandedTemplateIds = <int>{};
  List<int> selectedTemplates = <int>[];

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
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final authProvider = context.read<AuthProvider>();
      final templates =
          await fetchMealTemplates(authProvider, client: _client);

      if (!mounted) return;
      setState(() {
        _templates = templates;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Noget gik galt. Prøv igen.';
      });
    } finally {
      if (mounted) {
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
            child: Text(
              'Redigér',
              style: AppTextStyles.headline4.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(
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
                      'Vælg skabelon(er)',
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
                                   _buildSearchField(),
                                   const SizedBox(height: 12),
                                   if (_error != null) _buildErrorBanner(),
                                   if (_templates.isEmpty)
                 _buildEmptyState()
                                   else
                  ..._templates.map(_buildTemplateCard),
                                   const SizedBox(height: 20),
                                   
                                   
                                   CustomButton(
                 text: 'Brug skabeloner',
                 size: ButtonSize.medium,
                 onTab: ()  async {
               
                   try {
                     final List<Ingredient> res = await useTemplatesWithIDs(
                       context.read<AuthProvider>(),
                       selectedTemplates,
                     );

                     
                     final List<Map<String, dynamic>> mappedIngredients =
                         res.map((ing) {
                       return {
                         'id': ing.id,
                         'name': ing.name,
                         'foodImageId': ing.foodImageId,
                       };
                     }).toList();

                     
                     
                       Navigator.pop(context, mappedIngredients);
                     
                   } catch (e) {
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
                       
                     ],
                   ),
                 ),
               ),   
                ],
              ),
            ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      readOnly: true,
      decoration: InputDecoration(
        hintText: 'Søg',
        filled: true,
        fillColor: Colors.white,
        prefixIcon: const Icon(Icons.search),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide:
              BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
      ),
    );
  }

  Widget _buildErrorBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _error ?? '',
              style: AppTextStyles.buttonTextSmall.copyWith(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: _loadTemplates,
            child: const Text('Prøv igen'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          const Icon(Icons.inbox, size: 48, color: Colors.grey),
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
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
            borderRadius: BorderRadius.circular(24),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: !isSelected? AppColors.secondary: AppColors.primary,
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


                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.white,
                      size: 35,
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
          if (meal.ingredients.isEmpty)
            Text(
              'Ingen ingredienser fundet',
              style: AppTextStyles.mediumText.copyWith(color: Colors.grey),
            )
          else
            ...meal.ingredients.map(
              (packedIngredient) => 
  
                  _buildIngredientItem(packedIngredient),

       ) ],
      ),
    );
  }
}
Widget _buildIngredientItem(PackedIngredient packedIngredient) {
  int ingImgID = packedIngredient.ingredient.foodImageId ?? 0;
  
  return Container( 
    margin: const EdgeInsets.symmetric(vertical: 6),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        ingImgID != 0 ? 
         
        FoodImage(
          foodImageId: ingImgID,
          width: 40,
          height: 40,
          ): Icon(
          Icons.image_outlined,
          size: 22,
          color: AppColors.secondary,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            packedIngredient.ingredient.name,
            style: AppTextStyles.mediumText,
          ),
        ),
        const Icon(
          Icons.chevron_right,
          color: AppColors.secondary,
        ),
      ],
    ),
  );
}