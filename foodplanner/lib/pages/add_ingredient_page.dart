import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/search_field.dart';
import 'package:foodplanner/components/settings_widget.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/models/ingredient.dart';
import 'package:foodplanner/pages/create_ingredient_page.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/ingredient_services.dart';
import 'package:foodplanner/components/custom_checkbox.dart';

class AddIngredientPage extends StatefulWidget {
  const AddIngredientPage({super.key});

  @override
  State<AddIngredientPage> createState() => _AddIngredientPageState();
}

class _AddIngredientPageState extends State<AddIngredientPage> {
  final List<Map<String, dynamic>> _ingredients = [];
  final TextEditingController _controller = TextEditingController();
  final List<ValueNotifier<bool>> _controllers = [];

  final ingredientServices = IngredientServices(
    apiUrl: ApiConfig.baseUrl,
  );

  @override
  void initState() {
    super.initState();
    _getIngredients();
  }

  Future<void> _getIngredients() async {
    try {
      final authProvider = AuthProvider(); // Initialize your AuthProvider
      final ingredients =
          await ingredientServices.fetchIngredientsByUserID(authProvider);
      setState(() {
        _ingredients.addAll(
            ingredients.map((e) => {'id': e.id, 'name': e.name}).toList());
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
                          'name': tempIngredient.name
                        });
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
                  leftIcon: SFIcons.sf_person_crop_circle_fill_badge_checkmark,
                  title: _ingredients[index]['name'],
                  type: SettingsType.items,
                  cta: CustomCheckbox(
                    controller: _controllers[index],
                    activeColor: AppColors.background,
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
}
