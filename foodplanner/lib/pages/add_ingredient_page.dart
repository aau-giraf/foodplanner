import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/search_field.dart';
import 'package:foodplanner/components/settings_widget.dart';
import 'package:foodplanner/models/ingredient.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/models/packed_ingredient.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';

class AddIngredientPage extends StatefulWidget {
  const AddIngredientPage({super.key});

  @override
  State<AddIngredientPage> createState() => _AddIngredientPageState();
}

class _AddIngredientPageState extends State<AddIngredientPage> {
  final List<String> _ingredients = [];
  final TextEditingController _controller = TextEditingController();

  void _addIngredient() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: InkWell(
              onTap: () {
                GoRouter.of(context).go('/create-meal');
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: SearchField(
                      controller: TextEditingController(),
                      hintText: 'Søg efter ingredienser',
                    ),
                  ),
                  CustomButton(
                    onTab: null,
                    text: 'Tilføj',
                    customWidth: 100,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return SettingsWidget(
                    title: "Banana",
                    type: SettingsType.items,
                    cta: CustomButton(onTab: _addIngredient, text: 'Tilføj'),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
