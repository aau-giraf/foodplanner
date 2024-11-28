import 'package:flutter/material.dart';
import 'package:foodplanner/components/nav_bar.dart'; // Import the FooterBar widget

class FeedbackChatPage extends StatelessWidget {
  const FeedbackChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback Chat'),
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: NavBar(currentPageIndex: 0),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Ensure footer is at the bottom
        children: [
          Expanded(
            child: Center(
              child: Text(
                'Feedback chat will be implemented here.',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
