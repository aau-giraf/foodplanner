import 'package:flutter/material.dart';

class LunchBox extends StatelessWidget {
  const LunchBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Madpakke side'),
      ),
      body: const Center(
        child: Text('Madpakke side'),
      ),
    );
  }
}
