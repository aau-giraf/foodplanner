import 'package:flutter/material.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:intl/intl.dart';
import 'package:foodplanner/config/colors.dart';
import 'landing_page_children_se_madpakke.dart'; // Correct import

class ParentLandingPageMadpakke extends StatelessWidget {
  const ParentLandingPageMadpakke({super.key});

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
              'Velkommen' + ' ' + 'Forældre',
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
                  Text(
                    'Madpakke i dag d. $currentDate',
                    style: AppTextStyles.standard,
                  ),
                  SizedBox(height: size.height * 0.02),
                  const Text(
                    'Madpakke text',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Container(
                    width: size.width * 0.6,
                    height: size.width * 0.6, // 40% of the screen height
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        'https://cdn-icons-png.flaticon.com/512/739/739249.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(child: Text('Image not available'));
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(child: CircularProgressIndicator());
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.05),
                  Center(
                    child: SizedBox(
                      width: size.width * 0.6, // Set the desired width
                      height: 50, // Set the desired height
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ChildLandingPageSeMadpakke()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shadowColor: Colors.black, // Set the shadow color to black
                          elevation: 5, // Set the elevation to create a shadow effect
                        ),
                        child: const Text('Se madpakke', style: AppTextStyles.buttonText),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.05),
            Center(
              child: SizedBox(
                width: size.width * 0.6, // Set the desired width
                height: 50, // Set the desired height
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChildLandingPageSeMadpakke()), // Skal navigere til feedback page, når den er lavet.
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shadowColor: Colors.black, // Set the shadow color to black
                    elevation: 5, // Set the elevation to create a shadow effect
                  ),
                  child: const Text('Se Feedback', style: AppTextStyles.buttonText),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}