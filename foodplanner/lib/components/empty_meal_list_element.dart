import 'package:flutter/material.dart';
import 'package:foodplanner/components/icon_button.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/month_picker.dart';
import 'package:foodplanner/config/text_styles.dart';

class EmptyMealListElement extends StatelessWidget {
  const EmptyMealListElement({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container( 
          width: MediaQuery.sizeOf(context).width,
          height: 120,
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
                Text(
                  'Madpakke i dag d. ${DateTime.now().day.toString()}. ${MonthPicker.pick(DateTime.now().month)}',
                  style: AppTextStyles.standard,
                ),

                SizedBox(height: 20),

                Text(
                  'Ingen madpakke at vise',
                  style: AppTextStyles.headline1,
                ),
              ]
            ),
          ),
        ),


        SizedBox(height: 40),

        CustomElevatedButton(
          onTab: () {}, 
          widget: Icon(Icons.add, color: AppColors.textSecondary),
          width: MediaQuery.sizeOf(context).width/2,
        ),
      ],
    );
  }
}