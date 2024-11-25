import 'package:flutter/material.dart';
import 'package:foodplanner/components/footer.dart'; // Import the FooterBar widget

class FeedbackChatPage extends StatelessWidget {
  const FeedbackChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback Chat'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ensure footer is at the bottom
        children: [
          Expanded(
            child: Center(
              child: Text(
                'Feedback chat will be implemented here.',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          FooterBar(), // Add the footer widget here
        ],
      ),
    );
  }
}