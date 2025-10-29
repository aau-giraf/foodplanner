import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/components/button.dart';
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
  final TextEditingController _controller = TextEditingController();
  final List<ValueNotifier<bool>> _controllers = [];
  Client? client;
  bool _isEditMode = false;

  final ingredientServices = IngredientServices(
    apiUrl: ApiConfig.baseUrl,
  );

  @override
  void initState() {
    super.initState();
    client = http.Client();

    _getIngredients();
  }

  Future<void> _getIngredients() async {
    try {
      // final authProvider = AuthProvider(); // Initialize your AuthProvider
      final ingredients =
          await ingredientServices.fetchIngredientsByUserID(authProvider);
      setState(() {
        _ingredients.addAll(
            ingredients.map((e) => {'id': e.id, 'name': e.name, 'foodImageId': e.foodImageId}).toList());
             _ingredients.sort((a, b ) => (a['name'] as String).toLowerCase().compareTo((b['name'] as String).toLowerCase()));
        _controllers.addAll(List.generate(_ingredients.length, (index) {
          final controller = ValueNotifier<bool>(false);
          return controller;
        }));
      });
    } catch (e) {
      // Handle error
      print('Failed to fetch ingredients: $e');
    }
  }

  List<Map<String, dynamic>> _getSelectedIngredients() {
    List<Map<String, dynamic>> selectedIngredients = [];
    for (int i = 0; i < _ingredients.length; i++) {
      if (_controllers[i].value) {
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
        _ingredients.removeAt(index);
        _controllers[index].dispose();
        _controllers.removeAt(index);
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
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: CustomButton(
                  onTab: () async {
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
                        _controllers.add(ValueNotifier<bool>(false));
                      });
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
              itemCount: _ingredients.length,
              itemBuilder: (BuildContext context, index) {
                return SettingsWidget(
                  leftWidget: FoodImage(
                    foodImageId: _ingredients[index]['foodImageId'],
                    width: 50,
                    height: 50,
                    borderRadius: 8.0,
                  ),
                  title: _ingredients[index]['name'],
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
                    : AdvancedSwitch(
                        controller: _controllers[index],
                        activeColor: AppColors.primary,
                        width: 60,
                      ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
