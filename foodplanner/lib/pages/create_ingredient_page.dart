import 'dart:developer' as developer;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/text_field.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/pages/camera_page.dart';
import 'package:foodplanner/services/food_image_service.dart';

import 'package:foodplanner/models/ingredient.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/ingredient_services.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class CreateIngredientPage extends StatefulWidget {
  const CreateIngredientPage({
    super.key,
  });

  @override
  State<CreateIngredientPage> createState() => _CreateIngredientPageState();
}

class _CreateIngredientPageState extends State<CreateIngredientPage> {
  TextEditingController ingredientNameController = TextEditingController();
  final ValueNotifier<bool> isButtonEnabled = ValueNotifier<bool>(false);
  Client? client;
  int? foodImageId; // Store the uploaded image ID

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

  // Method to create the ingredient
  Future<void> createIngredient() async {
    Ingredient newIngredient = Ingredient(
      id: 0,
      name: ingredientNameController.text,
      foodImageId: foodImageId, // Use the uploaded image ID
    );
    
    newIngredient = Ingredient.fromJson(
      jsonDecode(
        (await ingredientServices.createIngredient(
          client!,
          AuthProvider(),
          newIngredient.name,
          newIngredient.foodImageId,
        )).body,
      ),
    );
    if(mounted){
      Navigator.pop(context, newIngredient);
    } else {
      developer.log("Error while creating ingredient");
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
              valueListenable: isButtonEnabled,
              builder: (context, isEnabled, child) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomButton(
                    onTab: isEnabled
                        ? () {
                            // First dialog: Ask about adding an image
                            showCupertinoDialog(
                              context: context,
                              builder: (BuildContext alertContext) =>
                                  CupertinoAlertDialog(
                                title: Text('Vil du tilføje et billede af madvaren?'),
                                actions: <CupertinoDialogAction>[
                                  CupertinoDialogAction(
                                    isDefaultAction: true,
                                    onPressed: () async {
                                      // Close dialog first
                                      Navigator.pop(alertContext);
                                      // Navigate to camera page
                                      final image = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CameraPage(),
                                        ),
                                      );
                                      
                                      // If image was captured, upload it
                                      if (image != null) {
                                        final imageResponse = await UploadFoodImage(image);
                                        final int responseData = jsonDecode(imageResponse.body);
                                        setState(() {
                                          foodImageId = responseData;
                                        });
                                      }
                                      
                                       await createIngredient();
                                    },
                                    child: const Text("Ja"), 
                                  ),
                                  CupertinoDialogAction(
                                    isDestructiveAction: true,
                                    onPressed: () async{
                                       // Close image dialog
                                      Navigator.pop(alertContext);
                                      await createIngredient();
                                    },
                                    child: const Text('Nej'),
                                  ),
                                ],
                              ),
                            );
                           
                          
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