import 'package:flutter/material.dart';
import 'package:foodplanner/components/meal.dart';
import 'package:foodplanner/config/text_styles.dart';

class MealListElement extends StatelessWidget {
  final Meal meal;
  
  const MealListElement({
    super.key,
    required this.meal,
  });

  @override
  Widget build(BuildContext context) {
    // String formattedDate = DateFormat("d. MMMM", "da").format(meal.date!);
    
    return Container( 
      width: MediaQuery.sizeOf(context).width,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        //border: Border.all(color: Colors.grey),
        color: Color(0xffF2F2F2),
        boxShadow: [
          BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 1,
          offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
          padding: const EdgeInsets.only(top: 5, right: 5, left: 5, bottom: 25),
          child: Column(
            children: [
              // Text(
              //   'Madpakke i dag d. ${meal.date?.day.toString()}. ${MonthPicker.pick(meal.date?.month)}',
              //   style: AppTextStyles.standard,
              // ),

              // SizedBox(height: 20),

              Text(
                meal.title,
                style: AppTextStyles.headline1,
              ),

              // Spacer(),

              // Image.asset(
              //   ,
              //   height: 200.0,
              //   width: 200.0,
              // ),
              Container(height: 200, width: 200, color: Colors.blue, child: Text('Temporary box to show picture size'))

              // Spacer(),
              
              // CustomElevatedButton(
              //   onTab: () {},
              //   widget: Text('Se madpakke', style: AppTextStyles.buttonText,),
              //   backgroundColor: AppColors.secondary,
              //   width: MediaQuery.sizeOf(context).width/2,
              // )
            ]
          ),
        ),
    );
  }
}