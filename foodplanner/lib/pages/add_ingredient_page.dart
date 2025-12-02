import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/custom_checkbox.dart';
import 'package:foodplanner/components/image.dart';
import 'package:foodplanner/components/loading_animation.dart';
import 'package:foodplanner/components/search_field.dart';
import 'package:foodplanner/components/settings_widget.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/models/ingredient.dart';
import 'package:foodplanner/pages/create_ingredient_page.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/ingredient_services.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class AddIngredientPage extends StatefulWidget {
  final IngredientServices? ingredientServices;
  final AuthProvider? authProvider;
  final List<Map<String, dynamic>>? preSelectedIngredients;

  const AddIngredientPage({
    super.key,
    this.ingredientServices,
    this.authProvider,
    this.preSelectedIngredients,
  });

  @override
  State<AddIngredientPage> createState() => _AddIngredientPageState();
}

class _AddIngredientPageState extends State<AddIngredientPage> {
  late final AuthProvider authProvider;

  final List<Map<String, dynamic>> _ingredients = [];
  final List<Map<String, dynamic>> _filteredIngredients = [];
  final TextEditingController _controller = TextEditingController();

  final Map<dynamic, ValueNotifier<bool>> _controllersById = {};
  Client? client;
  bool _isEditMode = false;

  bool _isLoading = true;
  String? _error;

  final ingredientServices = IngredientServices(
    apiUrl: ApiConfig.baseUrl,
  );


  @override
  void initState() {
    super.initState();
    client = http.Client();

    authProvider = widget.authProvider ?? AuthProvider();

    _getIngredients();
  }

  Future<void> _getIngredients() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final ingredients =
          await ingredientServices.fetchIngredientsByUserID(authProvider);
      setState(() {
        _ingredients
          ..clear()
          ..addAll(ingredients
              .map((e) =>
                  {'id': e.id, 'name': e.name, 'foodImageId': e.foodImageId})
              .toList());
        _ingredients.sort((a, b) => (a['name'] as String)
            .toLowerCase()
            .compareTo((b['name'] as String).toLowerCase()));

        // Preserve existing controllers where possible so selection isn't lost
        final Map<dynamic, ValueNotifier<bool>> newControllers = {};
        for (final ing in _ingredients) {
          final id = ing['id'];
          if (_controllersById.containsKey(id)) {
            newControllers[id] = _controllersById[id]!;
          } else {
            // Check if this ingredient is preselected
            final isPreSelected = widget.preSelectedIngredients
                    ?.any((selected) => selected['id'] == id) ??
                false;
            newControllers[id] = ValueNotifier<bool>(isPreSelected);
          }
        }
        // Dispose any controllers that no longer correspond to an ingredient
        for (final id in _controllersById.keys) {
          if (!newControllers.containsKey(id)) {
            try {
              _controllersById[id]?.dispose();
            } catch (_) {}
          }
        }
        _controllersById
          ..clear()
          ..addAll(newControllers);

        // Initialize filtered list to show all ingredients initially
        _filteredIngredients
          ..clear()
          ..addAll(_ingredients);
      });
    } catch (e) {
      developer.log('Failed to fetch ingredients: $e');
      setState(() {
        _error = 'Kunne ikke hente ingredienser';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Update filtered list based on entered keyword
  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = _ingredients;
    } else {
      results = _ingredients
          .where((ing) => (ing['name'] as String)
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _filteredIngredients
        ..clear()
        ..addAll(results);
    });
  }

  List<Map<String, dynamic>> _getSelectedIngredients() {
    List<Map<String, dynamic>> selectedIngredients = [];
    for (int i = 0; i < _ingredients.length; i++) {
      final id = _ingredients[i]['id'];
      final controller = _controllersById[id];
      if (controller != null && controller.value) {
        selectedIngredients.add(_ingredients[i]);
      }
    }
    return selectedIngredients;
  }

  Future<void> _deleteIngredient(int index) async {
     try {
    final messenger = ScaffoldMessenger.of(context);
    // Get the ingredient from the filtered list
    final filteredItem = _filteredIngredients[index];
    final id = filteredItem["id"] as int;
    final authProvider = AuthProvider();
    final response = await ingredientServices.deleteIngredient(client!, authProvider, id);
    
    if (response.statusCode == 500) {
      // Handle 500 error specifically
      messenger.showSnackBar(
        SnackBar(
          content: Text('Ingredient kan ikke slettes, da den er brugt i mindst en madpakke'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
    } else if (response.statusCode != 200) {
      // Handle other non-200 status codes
      messenger.showSnackBar(
        SnackBar(
          content: Text('Der opstod et ukendt problem ved fjernelsen af en ingredient: ${response.statusCode}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
    } else {
      // Success - remove from list
      setState(() {
        if (_controllersById.containsKey(id)) {
          _controllersById[id]?.dispose();
          _controllersById.remove(id);
        }

        _ingredients.removeWhere((ing) => ing['id'] == id);
        _filteredIngredients.removeWhere((ing) => ing['id'] == id);
      });
    }
  } catch (e) {
    // Handle network errors or exceptions
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Der opstod et ukendt problem ved fjernelsen af en ingredient: $e'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 5),
      ),
    );
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
              Navigator.pop(context, _getSelectedIngredients());
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
                _isEditMode ? 'Færdig' : 'Rediger',
                style: AppTextStyles.headline4.copyWith(
                  color: AppColors.primary,
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
          ? const Center(
              child: LoadingAnimation(imagePath: 'assets/images/logo.png'),
            )
          : RefreshIndicator(
              onRefresh: _getIngredients,
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                physics: AlwaysScrollableScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Ingredienser',
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
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          _buildSearchAndAddRow(),
                          const SizedBox(height: 12),
                          if (_error != null) _buildErrorBanner(),
                          if (_filteredIngredients.isEmpty)
                            _buildEmptyState()
                          else
                           SizedBox(
            height: 600, 
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredIngredients.length,
              itemBuilder: (context, index) {
                return _buildIngredientCard(_filteredIngredients[index]);
              })),
              
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: CustomButton(
                      text: 'Vælg ingredienser',
                      size: ButtonSize.medium,
                      onTab: () {
                        Navigator.pop(context, _getSelectedIngredients());
                      },
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70, right: 4),
        child: FloatingActionButton(
          backgroundColor: AppColors.primary,
          onPressed: () async {
            // Clear search input and show full list before navigating
            _controller.clear();
            _runFilter('');

            final ingredient = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateIngredientPage(),
              ),
            );

            if (ingredient != null) {
              final tempIngredient = ingredient as Ingredient;
              setState(() {
                _ingredients.add({
                  'id': tempIngredient.id,
                  'name': tempIngredient.name,
                  'foodImageId': tempIngredient.foodImageId
                });
                _ingredients.sort((a, b) => (a['name'] as String)
                    .toLowerCase()
                    .compareTo((b['name'] as String).toLowerCase()));
                _controllersById[tempIngredient.id] =
                    ValueNotifier<bool>(false);
              });
              _runFilter(_controller.text);
            }
          },
          child: const Icon(Icons.add, color: Colors.white, size: 30),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildSearchAndAddRow() {
    return Row(
      children: [
        Expanded(
          child: SearchField(
            controller: _controller,
            hintText: 'Søg efter ingredienser',
            onChanged: _runFilter,
          ),
        ),
      ],
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
            onPressed: _getIngredients,
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
          const Icon(Icons.inbox_sharp, size: 48, color: Colors.grey),
          const SizedBox(height: 12),
          Text(
            'Ingen ingredienser at vise',
            style: AppTextStyles.mediumText,
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientCard(Map<String, dynamic> ingredient) {
    final id = ingredient['id'];
    final controller = _controllersById.putIfAbsent(id, () {
      final isPreSelected = widget.preSelectedIngredients
              ?.any((selected) => selected['id'] == id) ??
          false;
      return ValueNotifier<bool>(isPreSelected);
    });

    return ValueListenableBuilder<bool>(
      valueListenable: controller,
      builder: (context, isSelected, _) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
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
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () {
              if (_isEditMode) return;
              controller.value = !controller.value;
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  ingredient['foodImageId'] != null
                      ? FoodImage(
                          foodImageId: ingredient['foodImageId'],
                          width: 40,
                          height: 40,
                          borderRadius: 8.0,
                        )
                      : Icon(
                          Icons.image_outlined,
                          size: 32,
                          color: AppColors.secondary,
                        ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      ingredient['name'] as String,
                      style: AppTextStyles.bigText.copyWith(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (_isEditMode)
                    InkWell(
                      onTap: () {
                        final index =
                            _filteredIngredients.indexOf(ingredient);
                        if (index != -1) {
                          _deleteIngredient(index);
                        }
                      },
                      child: const Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 30,
                      ),
                    )
                  else
                    Icon(
                      Icons.chevron_right,
                      color: isSelected ? Colors.white : AppColors.secondary,
                      size: 30,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    for (final c in _controllersById.values) {
      try {
        c.dispose();
      } catch (_) {}
    }
    super.dispose();
  }
}
