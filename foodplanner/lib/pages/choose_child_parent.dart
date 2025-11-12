import 'package:flutter/material.dart';
import 'package:foodplanner/components/nav_bar.dart';

class ChooseChildParent extends StatelessWidget {
  
  const ChooseChildParent ({
    super.key,
  });

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
      bottomNavigationBar: NavBar(currentPageIndex: 1),
    );
  }
}