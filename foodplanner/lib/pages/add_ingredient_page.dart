import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodplanner/components/ingredient.dart';
import 'package:foodplanner/components/meal.dart';
import 'package:foodplanner/components/packed_ingredient.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';

/// This class is used for selecting which ingredients should be added to the meal.
class AddIngredientPage extends StatefulWidget {
  final Meal meal; // The identifier of the meal which the ingredient should be added to.
  final VoidCallback onCamera;

  const AddIngredientPage({
    super.key,
    required this.meal,
    required this.onCamera,
  });
  
  static const String routeName = '/add_ingredient_page';

  @override
  _AddIngredientPageState createState() => _AddIngredientPageState();
}

class _AddIngredientPageState extends State<AddIngredientPage> {
  TextEditingController _searchBarController = TextEditingController();
  
  // @override
  // void initState() {
  //   super.initState();

  //   _searchBarController.addListener();
  // }


  @override
  void dispose() {
    _searchBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    List<Ingredient> ingredients = <Ingredient>[ // This list contains all the available ingredients.
      Ingredient(name: 'Knækbrød'),       /// TEST ///
      Ingredient(name: 'ost:brie'),       /// TEST ///
      Ingredient(name: 'ost:mozeralla'),  /// TEST ///
      Ingredient(name: 'æble'),           /// TEST ///
      Ingredient(name: 'banan'),          /// TEST ///
    ];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Find madvare"),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 1.0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),

      body: _buildAddIngredientPage(context, widget.meal, ingredients)

      // !!! Chat GPT !!!
      // Use FutureBuilder to handle the asynchronous fetchMeal
      // body: FutureBuilder<List<Ingredient>>(
      //   future: fetchIngredients(), // use JWT token
      //   builder: (BuildContext context, AsyncSnapshot<List<Ingredient>> ingredientsSnapshot) {
      //     if (ingredientsSnapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(child: CircularProgressIndicator()); // Show loader while fetching ingredients
      //     } else if (ingredientsSnapshot.hasError) {
      //       return Center(child: Text('Error: ${ingredientsSnapshot.error}')); // Show error if fetching ingredients fails
      //     } else if (ingredientsSnapshot.hasData) {
      //       final ingredients = ingredientsSnapshot.data!;
      //       return _buildAddIngredientPage(context, widget.meal, ingredients); // Build the page with ingredients
      //     } else {
      //       return const Center(child: Text('No ingredients found.'));
      //     }
      //   },
      // ),
    );
  }

  Widget _buildAddIngredientPage(BuildContext context, Meal meal, List<Ingredient> ingredients) {
    List<Ingredient> sortedIngredients = ingredients;

    return Column(
      children: [
        // The search field for the user to search for specific ingredients.
        Padding(
          padding: EdgeInsets.only(top: 5, right: 16, left: 16),
          child: TextField(
            controller: _searchBarController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Skriv her...',
              hintStyle: TextStyle(
                color: AppColors.textFieldHint,
              ),
              filled: true,
              fillColor: AppColors.textFieldBackground,
            ),
            onChanged: (text) {
              setState(() {
                sortedIngredients = ingredients.where((ingredient) {
                  return ingredient.name.toLowerCase().contains(text.toLowerCase());
                }).toList();
              });
            },
          ),
        ),

        Divider(color: AppColors.textFieldBorder,),

        // The list of available ingredients.
        Expanded(
          child: ListView.separated(
            itemCount: sortedIngredients.length, // Creates an element for each item in the ingredients list.
            itemBuilder: (BuildContext context, int index) {
              return TextButton(
                onPressed: () {
                  if(sortedIngredients[index].image == null) { // Chekcs if the ingredient has an image.
                    showCupertinoDialog( // If not, it opens a pop-up window.
                      context: context, 
                      builder: (BuildContext context) => CupertinoAlertDialog(
                        title: Text('Der er ikke et billede til denne ingrediens, tilføj dette nu.'),
                        actions: <CupertinoDialogAction>[
                          CupertinoDialogAction(
                            isDefaultAction: true,
                            onPressed: () { // Leads the user to the camera page.
                              widget.onCamera();
                            },
                            child: const Text("OK"),
                          ),
                        ],
                      )
                    );
                  } else {
                    createPackedIngredient(meal, sortedIngredients[index], 0);
                  }
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  )
                ), 
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(sortedIngredients[index].name, style: AppTextStyles.standard),
                )
              );
            }, 
            separatorBuilder: (BuildContext context, int index) {
              return Divider(color: AppColors.textFieldBorder,);
            },
          )
        ),
        Divider(color: AppColors.textFieldBorder,),
      ],
    );
  }
}