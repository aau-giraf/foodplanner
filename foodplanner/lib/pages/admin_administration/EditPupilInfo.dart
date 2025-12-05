import 'package:flutter/material.dart';
import 'package:foodplanner/models/pupil.dart';

class EditPupilInfo extends StatelessWidget {
  final Pupil pupil;

  const EditPupilInfo({super.key, required this.pupil});

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
            'Redigere elev ${pupil.firstName}',
            style: TextStyle(fontSize: 36),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}