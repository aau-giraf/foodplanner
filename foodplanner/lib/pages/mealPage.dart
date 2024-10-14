import 'package:flutter/material.dart';
import 'package:foodplanner/pages/add_ingredient_page.dart';
import '/pages/cameraPage.dart';

class MealPage extends StatelessWidget {
  const MealPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () {
        //     // Siden den skal tilbage til :)
        //   }, 
        // ),
        title: const Text("Opret madpakke"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1.0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                // Navigér til en anden side
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CameraPage()),
                );
              },
              child: Container( 
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey)
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 40,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // text 
            TextField(
              decoration: InputDecoration(
                labelText:'Giv den en titel!',
                hintText: 'Skriv her...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // add Ingredient button
            ElevatedButton.icon(
              onPressed: ()
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddIngredientPage(meal: )),
                );
              }, 
              icon: const Icon(Icons.add),
              label: const Text('Beskriv ingredienserne'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)
                ),
              ),            ),
            Spacer(),

            //create meal button
            ElevatedButton(
              onPressed: () {
                // Handle meal
              },
              child:Text('Opret madpakke'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)
                ),
              ),
            ),
          ],
        )
      ),
    );
      

    //   bottomNavigationBar: BottomNavigationBar(
    //     currentIndex: 0, // Set the current index
    //     items: const <BottomNavigationBarItem> [
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.home), 
    //         label: 'Home',         
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.inventory),
    //         label: 'Meal',     
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.person),
    //         label: 'Profile',
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.settings),
    //         label: 'Settings',
    //       ),
    //     ],
    //     selectedItemColor: Colors.orange,  // Optional: Highlight the selected item color
    //     unselectedItemColor: Colors.grey,  // Optional: Unselected items color
    //   )
    // );
  }
}
