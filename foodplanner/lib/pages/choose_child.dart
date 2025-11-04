import 'package:flutter/material.dart';

class ChooseChild extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 15),
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