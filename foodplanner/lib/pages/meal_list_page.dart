import 'package:flutter/material.dart';
import 'package:foodplanner/components/empty_meal_list_element.dart';
import 'package:foodplanner/components/icon_button.dart';
import 'package:foodplanner/components/meal_list_element.dart';
import 'package:foodplanner/models/meal.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:go_router/go_router.dart';

/// This class is used for creating the page, where the user can see all their meals.
class MealListPage extends StatelessWidget {
  const MealListPage({
    super.key, // Key for the widget, used for maintaining state.
  });

  static const String routeName = '/meal_list_page'; // Route name for navigating to this page.

  @override
  Widget build(BuildContext context) {
    dynamic meals = <Meal>[ // List of meals that will be shown
      // Meal(title: 'Knækbrød med ost + frugt', date: DateTime.now())     /// TEST ///
    ];

    return Scaffold( // Scaffold provides the basic structure for the page.
      appBar: AppBar( // AppBar at the top of the page.
        title: const Text("Velkommen, ."), // Title displayed in the AppBar.
        centerTitle: true, // Centers the title in the AppBar.
        backgroundColor: Colors.white, // Background color for the AppBar.
        elevation: 1.0, // Shadow effect under the AppBar.
        iconTheme: const IconThemeData(color: Colors.black), // Color of the icons in the AppBar.
        titleTextStyle: const TextStyle( // Style for the title text in AppBar.
          color: Colors.black, // Text color for the title.
          fontSize: 18, // Font size of the title text.
          fontWeight: FontWeight.bold, // Bold font weight for the title.
        ),
      ),
      
      // Meal elements are added to the page.
      body: Padding( // Adds padding around the body content.
        padding: const EdgeInsets.all(16.0), // Padding values for all sides.
        child: Column( // Vertical layout for the page.
          children: [
            Expanded( // Expands to fill available space, allowing flexibility in height.
              child: meals.isEmpty // Checks if the meals list is empty.
              ? EmptyMealListElement() // Displays when there are no meals.
              : ListView.separated( // Shows the empty list element if there exists no meals. Otherwise, it will show all meals for the user.
                  itemCount: meals.length, // Number of items in the meals list.
                  itemBuilder: (context, index) { // Runs for the amount of elements that exists in the meals list.
                    return MealListElement(meal: meals[index]); // Passes the meal to the MealListElement.
                  },
                  separatorBuilder: (BuildContext context, int index) { // Creates spacing between the elements.
                    return const SizedBox(height: 10); // Space between elements.
                  },
                ),
            ),
            
            const SizedBox(height: 40), // Added spacing
            
            // The button for creating a new meal
            CustomElevatedButton(
              onTab: () { // Leads to the "add_meal_page"
                context.go(ADD_MEAL_PAGE);
              },
              widget: Icon(Icons.add, color: AppColors.textSecondary), // Icon displayed on the button.
              width: MediaQuery.sizeOf(context).width / 2, // Button width is half the screen width.
            ),
          ],
        ),
      ),
    );
  }
}