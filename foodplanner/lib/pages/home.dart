import 'package:flutter/material.dart';
import 'package:foodplanner/config/colors.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      appBar: AppBar(
        title: const Text('Hjem'),
      ),
      body: const Center(
        child: Text('Hjem'),
      ),
    );
  }
}
