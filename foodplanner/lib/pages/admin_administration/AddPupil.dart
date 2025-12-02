import 'package:flutter/material.dart';
import 'package:foodplanner/components/text_field.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:image/image.dart';


  final controller = TextEditingController();

  Map<int, bool> isEditing = {};
  Map<int, TextEditingController> controllers = {};

class AddPupil extends StatelessWidget {
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
            'Tilføj ny elev',
            style: TextStyle(fontSize: 36),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(  
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 150),  
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Elev navn:",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(width: 20,),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.zero)
                          
                        ),
                        hintText: "Navn" ,
                      ),
                    )
                  ),
                  SizedBox(height: 60,),

                  Expanded(
                    child: TextButton(
                      onPressed: () {

                      }, 
                      style: TextButton.styleFrom(backgroundColor: AppColors.background),
                      child: Text("Gem"),
                    )
                  )
                ],
              )
            ],
          )
        ),
      ),
    );
  }
}