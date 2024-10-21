import 'package:flutter/material.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';

class ChildLandingPageSeMadpakke extends StatefulWidget {
  const ChildLandingPageSeMadpakke({super.key});

  @override
  _ChildLandingPageSeMadpakkeState createState() => _ChildLandingPageSeMadpakkeState();
}

class _ChildLandingPageSeMadpakkeState extends State<ChildLandingPageSeMadpakke> {
  bool isDraggingOver = false; // Add this line to define the variable
  List<Map<String, String>> foodItems = [
    {'imageUrl': 'https://cdn-icons-png.flaticon.com/512/739/739249.png  ', 'description': 'Knækbrød med ost'},
    {'imageUrl': 'https://cdn-icons-png.flaticon.com/512/739/739249.png  ', 'description': 'Æble'},
    {'imageUrl': 'https://cdn-icons-png.flaticon.com/512/739/739249.png  ', 'description': 'Banan'},
    {'imageUrl': 'https://cdn-icons-png.flaticon.com/512/739/739249.png  ', 'description': 'Sandwich'},
    {'imageUrl': 'https://cdn-icons-png.flaticon.com/512/739/739249.png  ', 'description': 'Yoghurt'},
   
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final containerHeight = size.height * 0.70; // Invisible scrollable box height 

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            
          

          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 0, left: 20), // Adjust padding to move content up and to the right
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
              Text(
              'Madpakke',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Container(
              height: containerHeight, 
              child: SingleChildScrollView(
                child: Column(
                  children: foodItems
                      .asMap()
                      .entries
                      .map((entry) => _buildDraggableFoodBox(entry.key, entry.value['imageUrl']!, entry.value['description']!))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Add your button action here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text('Hjælp mig', style: AppTextStyles.buttonText),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDraggableFoodBox(int index, String imageUrl, String description) {
    final size = MediaQuery.of(context).size;
    final boxWidth = size.width * 0.9; // 90% of the screen width
    final boxHeight = size.height * 0.2; // 20% of the screen height

    return Container(
      width: boxWidth,
      height: boxHeight,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10), // Add padding around image
      decoration: BoxDecoration(
        border: Border.all(color: isDraggingOver ? Colors.blue : Colors.grey),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 243, 243, 243),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Flexible(
                flex: 6,
                child: Container(
                  height: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), // Round the edges on both sides
                    border: Border.all(color: const Color.fromARGB(255, 100, 100, 100), width: 0.5), // Add black border around the image
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20), // Round the edges on both sides
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(child: Text('Image not available'));
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 4,
                child: Container(
                  height: double.infinity,
                  padding: const EdgeInsets.only(left: 35, right: 8, top: 8, bottom: 8), // Add left padding to move the text to the righ
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
                  ),
                  child: Center(
                    child: Text(
                      description,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            right: 0,
            child: Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_upward),
                  onPressed: () {
                    if (index > 0) {
                      setState(() {
                        final item = foodItems.removeAt(index);
                        foodItems.insert(index - 1, item);
                      });
                    }
                  },
                ),
                SizedBox(height: boxHeight-100),
                IconButton(
                  icon: const Icon(Icons.arrow_downward),
                  onPressed: () {
                    if (index < foodItems.length - 1) {
                      setState(() {
                        final item = foodItems.removeAt(index);
                        foodItems.insert(index + 1, item);
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}