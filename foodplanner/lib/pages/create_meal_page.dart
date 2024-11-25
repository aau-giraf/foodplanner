import 'package:flutter/material.dart';

class CreateMealPage extends StatelessWidget {
  const CreateMealPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Meal'),
      ),
      body: Center(
        child: Text(
          'Meal creation will be implemented here.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}