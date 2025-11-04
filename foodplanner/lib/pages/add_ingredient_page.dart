import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/custom_checkbox.dart';
import 'package:foodplanner/components/image.dart';
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

  const AddIngredientPage({
    super.key,
    this.ingredientServices,
    this.authProvider,
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
    try {
      // final authProvider = AuthProvider(); // This should be injected so we can test it
      final ingredients =
          await ingredientServices.fetchIngredientsByUserID(authProvider);
      setState(() {
        _ingredients.addAll(
            ingredients.map((e) => {'id': e.id, 'name': e.name, 'foodImageId': e.foodImageId}).toList());
             _ingredients.sort((a, b ) => (a['name'] as String).toLowerCase().compareTo((b['name'] as String).toLowerCase()));
        // Preserve existing controllers where possible so selection isn't lost
        final Map<dynamic, ValueNotifier<bool>> newControllers = {};
        for (final ing in _ingredients) {
          final id = ing['id'];
          if (_controllersById.containsKey(id)) {
            newControllers[id] = _controllersById[id]!;
          } else {
            newControllers[id] = ValueNotifier<bool>(false);
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
        _filteredIngredients.clear();
        _filteredIngredients.addAll(_ingredients);
      });
    } catch (e) {
      // Handle error
      print('Failed to fetch ingredients: $e');
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
    final id = _ingredients[index]["id"];
    final authProvider = AuthProvider();
    final response = await ingredientServices.deleteIngredient(client!, authProvider, id);
    
    if (response.statusCode == 500) {
      // Handle 500 error specifically
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ingredient kan ikke slettes, da den er brugt i mindst en madpakke'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
    } else if (response.statusCode != 200) {
      // Handle other non-200 status codes
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Der opstod et ukendt problem ved fjernelsen af en ingredient: ${response.statusCode}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
    } else {
      // Success - remove from list
      setState(() {
        final id = _ingredients[index]['id'];
        if (_controllersById.containsKey(id)) {
          _controllersById[id]?.dispose();
          _controllersById.remove(id);
        }

        _ingredients.removeAt(index);
        _filteredIngredients.removeWhere((ing) => ing['id'] == id);
      });
    }
  } catch (e) {
    // Handle network errors or exceptions
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
      body: Column(
        children: [
          SettingsWidget(
            leftIcon: SFIcons.sf_person_crop_circle_fill_badge_checkmark,
            title: 'Tilføj ingredienser',
            subTitle:
                'Her kan du tilføje ingredienser til din madpakke.\nDu kan tilføje ingredienser fra din egen liste eller tilføje nye ingredienser.',
            type: SettingsType.header,
          ),
          Row(
            children: [
              Expanded(
                child: SearchField(
                  controller: _controller,
                  hintText: 'Søg efter ingredienser',
                  onChanged: _runFilter,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: CustomButton(
                  onTab: () async {
                    // Clear search input and show full list before navigating
                    _controller.clear();
                    _runFilter('');
                    // go to create ingredient page
                    final ingredient = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateIngredientPage(),
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
                          _ingredients.sort((a, b) =>  (a['name'] as String).toLowerCase().compareTo((b['name'] as String).toLowerCase()));
                          _controllersById[tempIngredient.id] = ValueNotifier<bool>(false);
                        });
                        _runFilter(_controller.text);
                    }
                  },
                  text: 'Tilføj',
                  customWidth: 100,
                ),
              ), 
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredIngredients.length,
              itemBuilder: (BuildContext context, index) {
                // Find the index of the filtered item in the original list to get the right controller
                final filteredItem = _filteredIngredients[index];
                final id = filteredItem['id'];
                // Ensure a stable controller exists for this id (create if missing)
                final controller = _controllersById.putIfAbsent(id, () => ValueNotifier<bool>(false));

                return SettingsWidget(
                  key: ValueKey(id),
                  leftWidget: FoodImage(
                    foodImageId: _filteredIngredients[index]['foodImageId'],
                    width: 50,
                    height: 50,
                    borderRadius: 8.0,
                  ),
                  title: _filteredIngredients[index]['name'],
                  type: SettingsType.items,
                  cta: _isEditMode
                    ? InkWell(
                        onTap: () => _deleteIngredient(index),
                        child: Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 45,
                        ),
                      )
                    : CustomCheckbox(
                        controller: controller,
                        activeColor: AppColors.primary,
                        size: 40,
                    ),
                );
              },
            ),
          ),
        ],
      ),
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
