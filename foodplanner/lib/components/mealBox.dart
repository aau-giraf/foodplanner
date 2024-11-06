import 'package:flutter/material.dart';
import 'package:foodplanner/components/mealBoxContent.dart';
import 'package:foodplanner/components/mealBoxEmpty.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/pages/landing_page_children_se_madpakke.dart'; // Update with the correct import
import 'package:foodplanner/components/dateTimePicker.dart';

class ReusableMealBox extends StatelessWidget {
  final Size size;
  final isMadpakkeEmpty = false;//later we want to check with a fetch whether there is a box or not
  final String imageUrl;
  final String caption;

  const ReusableMealBox({
  Key? key, 
  required this.size}) :
  caption = 'Madpakke Tekst',
  imageUrl = 'https://cdn-icons-png.flaticon.com/512/739/739249.png', // when we fetch we change here so the result is displayed (the picture from minio)
  super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 0.9, // 90% of the screen width
      height: isMadpakkeEmpty ? size.height * 0.2 : size.height * 0.1 + size.width * 0.6 + 190, // "dynamic" height, if mealbox is empty its smaller
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 243, 243, 243), // image box background color
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(40),
        boxShadow: [ // love sabrina carpenter
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DateTimePickerWidget(),
          
          isMadpakkeEmpty
              ? Mealboxempty(size: size)
              : Mealboxcontent(size: size, imageUrl: imageUrl, caption: caption),
          
        
          
        ],
      ),
    );
  }
}

