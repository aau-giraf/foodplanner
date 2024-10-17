import 'package:flutter/material.dart';
import 'landing_page_children_se_madpakke.dart'; // Correct import

class ChildLandingPageMadpakke extends StatelessWidget {
  const ChildLandingPageMadpakke({super.key});

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
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.network(
                  'https://example.com/static_image.jpg', // Replace with your image URL
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
              const SizedBox(height: 20),
              const Text(
                'Placeholder text for the madpakke page.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChildLandingPageSeMadpakke()),
                  );
                },
                child: const Text('Se madpakke'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}