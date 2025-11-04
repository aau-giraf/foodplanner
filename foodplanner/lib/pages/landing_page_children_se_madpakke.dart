import 'package:flutter/material.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/models/packed_ingredient.dart';
import 'package:foodplanner/services/meal_notifier.dart';
import 'package:foodplanner/services/packed_ingredient_services.dart';
import 'package:provider/provider.dart';
import 'package:foodplanner/components/image.dart';

class ChildLandingPageSeMadpakke extends StatefulWidget {
  const ChildLandingPageSeMadpakke({super.key});

  @override
  _ChildLandingPageSeMadpakkeState createState() =>
      _ChildLandingPageSeMadpakkeState();
}

class _ChildLandingPageSeMadpakkeState
    extends State<ChildLandingPageSeMadpakke> {
  bool isDraggingOver = false; // Add this line to define the variable

  List<PackedIngredient> packedIngredients = [];

  @override
  void initState() {
    super.initState();
    final mealNotifier = Provider.of<MealNotifier>(context, listen: false);
    packedIngredients = mealNotifier.meal!.ingredients;
  }

Widget ingredientCard(int? foodImageId, String description) {
  return Card(
    color: AppColors.background,
    elevation: 2,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FoodImage(foodImageId: foodImageId),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Text(
              description,
              style: AppTextStyles.headline4,
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Madpakke',
          style: AppTextStyles.title,
          textAlign: TextAlign.center,
        ),
      ),
      backgroundColor: Colors.white,
      body: ReorderableListView(
        children: [
          for (int index = 0; index < packedIngredients.length; index++)
            ListTile(
              key: Key('$index'),
              title: ingredientCard(
    packedIngredients[index].ingredient.foodImageId,  
    packedIngredients[index].ingredient.name)
            ),
        ],
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final item = packedIngredients.removeAt(oldIndex);
            packedIngredients.insert(newIndex, item);
            // set the order number for each packed ingredient
            for (int i = 0; i < packedIngredients.length; i++) {
              packedIngredients[i].orderNumber = i;
            }
            updatePackedIngredientOrder(packedIngredients);
          });
        },
      ),
    );
  }
}
