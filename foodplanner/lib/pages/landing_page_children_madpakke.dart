import 'package:flutter/material.dart';
import 'package:foodplanner/components/dateTimePicker.dart';
import 'package:foodplanner/components/mealBox.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:intl/intl.dart'; // Import the reusable widget

class ChildLandingPageMadpakke extends StatelessWidget {
  const ChildLandingPageMadpakke({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current date   
    String currentDate = DateFormat('dd. MMMM').format(DateTime.now());

    // Get the size of the screen
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'Welcome' + ' ' + 'Child',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: size.height * 0.02),
            Container(
              width: size.width * 0.9, // 90% of the screen width
              height: size.height * 0.1 + size.width * 0.6 + 190, // 70% of the screen height
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 243, 243, 243), // image box background color
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
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
                  SizedBox(height: size.height * 0.02),
                  const Text(
                    'Madpakke text',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: size.height * 0.02),
                  ReusableMealBox(size: size), // Use the reusable widget
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}