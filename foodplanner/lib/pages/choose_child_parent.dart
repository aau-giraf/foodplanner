import 'package:flutter/material.dart';

class ChooseChildParent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 200,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 25),
          child: Text(
            'Vælg barn',
            style: TextStyle(fontSize: 36),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}