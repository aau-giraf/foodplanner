import 'package:flutter/material.dart';

class ParentPage extends StatelessWidget {
   const ParentPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parent Page'),
      ),
      body: Center(
        child: Text('Welcome to the Parent Page!'),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ParentPage(),
  ));
}