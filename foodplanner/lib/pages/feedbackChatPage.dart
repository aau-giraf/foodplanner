import 'package:flutter/material.dart';

class FeedbackChatPage extends StatelessWidget {
  const FeedbackChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback Chat'),
      ),
      body: Center(
        child: Text(
          'Feedback chat will be implemented here.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}