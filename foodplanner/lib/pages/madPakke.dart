import 'package:flutter/material.dart';

class Madpakke extends StatelessWidget {
  const Madpakke({super.key});

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
