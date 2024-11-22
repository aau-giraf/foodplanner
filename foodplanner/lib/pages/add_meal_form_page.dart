import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/settings_widget.dart';
import 'package:foodplanner/models/ingredient.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/models/packed_ingredient.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:foodplanner/components/text_field.dart';

/// This class is used to create the meal page where the user can create an individual meal for their children.
class MealFormPage extends StatefulWidget {
  const MealFormPage({
    super.key,
  });

  @override
  _MealFormPageState createState() =>
      _MealFormPageState(); // Create the state for this page.
}

class _MealFormPageState extends State<MealFormPage> {
  // Method for deleting the controllers when they are done being used.

  @override
  void dispose() {
    super.dispose(); // Call the superclass dispose method.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: InkWell(
            onTap: () {
              GoRouter.of(context).go('/');
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: [
            SettingsWidget(
              leftIcon: SFIcons.sf_fork_knife,
              title: 'Opret madpakke',
              subTitle: 'Her kan du oprette en madpakke til dit barn',
              type: SettingsType.header,
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text('Navn på madpakke', style: AppTextStyles.mediumText),
                      CustomTextField(
                        controller: TextEditingController(),
                        errorText: "",
                        hintText: 'Navn fx. "Rugbrød med ost og grønt"',
                      ),
                      const SizedBox(height: 50), // Spacer for vertical layout.
                      CustomButton(
                        onTab: () =>
                            GoRouter.of(context).go('/add-ingridients'),
                        text: 'Tilføj ingredienser',
                        size: ButtonSize.medium,
                      ),
                      SizedBox(height: 20),

                      CustomButton(
                        onTab: () {
                          showCupertinoDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                CupertinoAlertDialog(
                              title: Text(
                                  'Vil du tilføje et billede af madpakken?'), // Title of the dialog.
                              actions: <CupertinoDialogAction>[
                                CupertinoDialogAction(
                                  isDefaultAction:
                                      true, // Highlight the default action.
                                  /*    onPressed: () async {
                                    Navigator.pop(context);
                                    await widget
                                        .onCamera(); // Calls the camera callback.
                                    widget.onCreateMeal(widget.client,
                                        widget.mealTitleController.text);
                                  }, */
                                  child: const Text(
                                      "Ja"), // Button text for "Yes".
                                ),
                                CupertinoDialogAction(
                                  isDestructiveAction:
                                      true, // Mark as a destructive action.
                                  /*                onPressed: () {
                                    Navigator.pop(context);
                                    widget.onCreateMeal(widget.client,
                                        widget.mealTitleController.text);
                                  }, */
                                  child: const Text(
                                      'Nej'), // Button text for "No".
                                ),
                              ],
                            ),
                          );
                        },
                        text: 'Opret madpakke',
                        size: ButtonSize.medium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
