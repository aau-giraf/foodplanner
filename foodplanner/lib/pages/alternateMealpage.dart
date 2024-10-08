import 'package:flutter/material.dart';
import 'package:foodplanner/pages/mealPage.dart';

class AlternateMealpage extends StatelessWidget {
  const AlternateMealpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ny side"),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate the height based on screen height percentages
          final totalHeight = constraints.maxHeight;
          final nameHeight = totalHeight * 0.10; // 10% for Name
          final textHeight = totalHeight * 0.50; // 50% for Text
          final descriptionHeight = totalHeight * 0.20; // 20% for Description
          final buttonHeight = totalHeight * 0.20; // 20% for Buttons

          return Column(
            children: [
              // Name TextField (10% of height)
              SizedBox(
                height: nameHeight,
                width: double.infinity,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),

              // Text TextField (50% of height)
              SizedBox(
                height: textHeight,
                width: double.infinity,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextField(
                    expands: true,
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: 'Text',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),

              // Description TextField (20% of height)
              SizedBox(
                height: descriptionHeight,
                width: double.infinity,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextField(
                    expands: true,
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),

              // Buttons (20% of height)
              SizedBox(
                height: buttonHeight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Use'),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Use + save'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
