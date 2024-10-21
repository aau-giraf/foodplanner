import 'package:flutter/material.dart';

class AdditionalLunchBox extends StatelessWidget {
  const AdditionalLunchBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      appBar: AppBar(
        title: const Text('Ekstra madpakke'),
      ),
      body: const Center(
        child: Text('Ekstra madpakke'),
      ),
    );
  }
}
