import 'package:flutter/material.dart';

class ChildLandingPageSeMadpakke extends StatefulWidget {
  const ChildLandingPageSeMadpakke({super.key});

  @override
  _ChildLandingPageSeMadpakkeState createState() => _ChildLandingPageSeMadpakkeState();
}

class _ChildLandingPageSeMadpakkeState extends State<ChildLandingPageSeMadpakke> {
  List<Map<String, String>> foodItems = [
    {'imageUrl': 'https://example.com/bread.jpg', 'description': 'Knækbrød med ost'},
    {'imageUrl': 'https://example.com/apple.jpg', 'description': 'Æble'},
    {'imageUrl': 'https://example.com/banana.jpg', 'description': 'Banan'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Se Madpakke'),
      ),
      body: Center(
        child: Container(
          width: 375, // Width of an iPhone screen
          height: 667, // Height of an iPhone screen
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: foodItems
                .asMap()
                .entries
                .map((entry) => _buildDraggableFoodBox(entry.key, entry.value['imageUrl']!, entry.value['description']!))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildDraggableFoodBox(int index, String imageUrl, String description) {
    return LongPressDraggable<Map<String, dynamic>>(
      data: {'index': index, 'imageUrl': imageUrl, 'description': description},
      feedback: Material(
        color: Colors.transparent,
        child: _buildFoodBox(imageUrl, description, index, isDragging: true),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _buildFoodBox(imageUrl, description, index),
      ),
      child: DragTarget<Map<String, dynamic>>(
        onAccept: (data) {
          setState(() {
            // Swap dragged item with the target item.
            final draggedItem = foodItems.removeAt(data['index'] as int);
            foodItems.insert(index, draggedItem);
          });
        },
        onWillAccept: (data) {
          return data?['index'] != index; // Allow drop only if it's not the same item.
        },
        builder: (context, candidateData, rejectedData) {
          return _buildFoodBox(
            imageUrl, 
            description, 
            index, 
            isDraggingOver: candidateData.isNotEmpty,
          );
        },
      ),
    );
  }

  Widget _buildFoodBox(String imageUrl, String description, int index, {bool isDragging = false, bool isDraggingOver = false}) {
    return Container(
      width: 300,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: isDraggingOver ? Colors.blue : Colors.grey),
        borderRadius: BorderRadius.circular(10),
        boxShadow: isDragging
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ]
            : [],
      ),
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
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
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
                ),
                child: Text(
                  description,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
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
