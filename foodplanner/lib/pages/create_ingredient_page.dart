import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/text_field.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/models/ingredient.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/ingredient_services.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

/// This class is used when creating a new ingredient in the system.
class CreateIngredientPage extends StatefulWidget {
  const CreateIngredientPage({
    super.key,
  });

  @override
  State<CreateIngredientPage> createState() => _CreateIngredientPageState();
}

/// The state of the page, which contains all the front-end elements,
class _CreateIngredientPageState extends State<CreateIngredientPage> {
  TextEditingController ingredientNameController =
      TextEditingController(); // The controller for the ingredient name text field.
  final ValueNotifier<bool> isButtonEnabled =
      ValueNotifier<bool>(false); // Notifier to track the button state.
  Client? client;

  final ingredientServices = IngredientServices(
    apiUrl: ApiConfig.baseUrl,
  );

  int maxTextLength = 20;

  @override
  void initState() {
    super.initState();
    client = http.Client();
    ingredientNameController.addListener(() {
      isButtonEnabled.value = ingredientNameController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    ingredientNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: InkWell(
            onTap: () {
              Navigator.pop(context, null);
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Text(
              "Tilføj madvare",
              style: AppTextStyles.headline2,
            ),
            SizedBox(height: 20),
            CustomTextField(
              controller: ingredientNameController,
              errorText: '',
              hintText: 'Skriv her...',
            ),
            SizedBox(height: 20),
            ValueListenableBuilder<bool>(
              valueListenable:
                  isButtonEnabled, // The listener connected to the text editing controller.
              builder: (context, isEnabled, child) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomButton(
                    onTab: isEnabled
                        ? () async {
                            Ingredient newIngredient = Ingredient(
                              id: 0,
                              name: ingredientNameController.text,
                              foodImageId: null,
                            );
                            newIngredient = Ingredient.fromJson(
                              jsonDecode(
                                (await ingredientServices.createIngredient(
                                  client!,
                                  AuthProvider(),
                                  newIngredient.name,
                                  newIngredient.foodImageId,
                                ))
                                    .body,
                              ),
                            );
                            Navigator.pop(context, newIngredient);
                          }
                        : null,
                    text: 'Opret madvare',
                    size: ButtonSize.large,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
