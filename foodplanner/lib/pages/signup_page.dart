import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/text_field.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  // Text editing controllers
  final fullNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final emailController = TextEditingController();

  //Regular expression for vildationg full name, Email, password¨
  final RegExp nameRegExp = RegExp(r'^[a-zA-ZæøåÆØÅ]+$');
  final RegExp emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
  final RegExp passwordRegExp = RegExp(r'^(?=.*[a-zæøå])(?=.*[A-ZÆØÅ])(?=.*\d)[a-zA-ZæøåÆØÅ\d]{8,30}$');

  //Function to validate form inputs
  void validateInputs(BuildContext context) {
    String fullName = fullNameController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    String email = emailController.text.trim();
    
    //Step 1: Check om alle felter er udfyldt
    if (fullName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      // Show an error message if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Alle felter skal være udfyldt.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
    }

    //Step 2: Full Name Validation
    
    if (!nameRegExp.hasMatch(fullName)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dit navn må kun indhold bogstaver'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
      return;
    }

    //Step 3: Email Validation
    if (!emailRegExp.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Det er ikke en gyldig email'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
      return;
    }

    //Step 4: Password Validation
    if (!passwordRegExp.hasMatch(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Adgangskode opfyldt ikke alle kraverne'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
      return;
    }

    //Step 5: Confirm Password Validation
    if (password != confirmPassword) {
        // Show an error message if passwords do not match
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Adgangskode passer ikke'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
       ),
      );
      return;
    }  

    //proceed with sign-up logic if everything is correct
    signUserUp(context);
  }

  //Placeholder function for sign-up logic
  void signUserUp(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opretter bruger...'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 5),
      ),
    );
  }

  void showButtonPressDialog(BuildContext context, String provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$provider Button Pressed!'),
        backgroundColor: Colors.black26,
        duration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBE9E9),
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            const SizedBox(height: 100),
            const SFIcon(
              SFIcons.sf_person_fill_badge_plus,
              fontSize: 100,
              fontWeight: FontWeight.w400,
            ),
            const SizedBox(height: 50),
            const Text(
              'Tilmeld dig herunde',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),
            CustomTextField(
                hintText: "Fulde Navn", controller: fullNameController),
            const SizedBox(height: 15),
            CustomTextField(
                hintText: "Email", controller: emailController),
            const SizedBox(height: 15),
            CustomTextField(
                hintText: "Adgangskode",
                obscureText: true,
                controller: passwordController),
            const SizedBox(height: 15),
            CustomTextField(
                hintText: "Gentage Adgangskode",
                obscureText: true,
                controller: confirmPasswordController),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 150),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
              ),
            ),
        

            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 150),
              child: Divider(
                color: Colors.black,
                thickness: 1,
              ),
            ),
            const SizedBox(height: 25),
            CustomButton(
              onTab: () => validateInputs(context),
              text: 'Tilmeld dig',
              MainColor: Colors.blue,
            ),
          ],
        ),
      )),
    );
  }
}


