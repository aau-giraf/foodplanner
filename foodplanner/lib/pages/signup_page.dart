import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/text_field.dart';
import 'package:foodplanner/components/user.dart';

class SignupPage extends StatefulWidget {
  SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // Text editing controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final emailController = TextEditingController();

  // Text error messages
  String firstNameError = '';
  String lastNameError = '';
  String emailError = '';
  String passwordError = '';
  String confirmPasswordError = '';

  //Regular expression for vildationg full name, Email, password¨
  final RegExp nameRegExp = RegExp(r'^[a-z A-ZæøåÆØÅ]+$');
  final RegExp emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
  final RegExp passwordRegExp =
      RegExp(r'^(?=.*[a-zæøå])(?=.*[A-ZÆØÅ])(?=.*\d)[a-zA-ZæøåÆØÅ\d]{8,30}$');

  void updateErrorState(String field, String error) {
    setState(() {
      switch (field) {
        case 'First_name':
          firstNameError = error;
          break;
        case 'Last_name':
          lastNameError = error;
          break;
        case 'Email':
          emailError = error;
          break;
        case 'Password':
          passwordError = error;
          break;
      }
    });
  }

  void handleErrors(Map<String, dynamic> error) {
    updateErrorState('First_name',
        error['First_name'] != null ? error['First_name'][0] : '');
    updateErrorState(
        'Last_name', error['Last_name'] != null ? error['Last_name'][0] : '');
    updateErrorState('Email', error['Email'] != null ? error['Email'][0] : '');
    updateErrorState(
        'Password', error['Password'] != null ? error['Password'][0] : '');
  }

  //Function to validate form inputs
  void validateInputs(BuildContext context) {
    String firstName = firstNameController.text.trim();
    String lastName = lastNameController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    String email = emailController.text.trim();

    //Step 1: Check om alle felter er udfyldt
    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
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
    if (!nameRegExp.hasMatch(firstName)) {
      setState(() {
        firstNameError = 'Dit navn må kun indholde bogstaver';
      });
      return;
    } else {
      setState(() {
        firstNameError = '';
      });
    }

    if (!nameRegExp.hasMatch(lastName)) {
      setState(() {
        lastNameError = 'Dit navn må kun indholde bogstaver';
      });
      return;
    } else {
      setState(() {
        lastNameError = '';
      });
    }

    //Step 3: Email Validation
    if (!emailRegExp.hasMatch(email)) {
      setState(() {
        emailError = 'Det er ikke en gyldig email';
      });
      return;
    } else {
      setState(() {
        emailError = '';
      });
    }

    //Step 4: Password Validation
    if (!passwordRegExp.hasMatch(password)) {
      setState(() {
        passwordError =
            'Adgangskoden skal være mellem 8 og 30 tegn og indeholde mindst et stort bogstav, et lille bogstav og et tal';
      });
      return;
    } else {
      setState(() {
        passwordError = '';
      });
    }

    //Step 5: Confirm Password Validation
    if (password != confirmPassword) {
      setState(() {
        confirmPasswordError = 'Adgangskoderne passer ikke';
      });
      return;
    } else {
      setState(() {
        confirmPasswordError = '';
      });
    }

    //proceed with sign-up logic if everything is correct
    signUserUp(context, firstName, lastName, email, password, confirmPassword);
  }

  //Placeholder function for sign-up logic
  void signUserUp(BuildContext context, String firstName, String lastName,
      String email, String password, String confirmPassword) async {
    try {
      final response = await createUser(firstName, lastName, email, password);

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bruger oprettet!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 5),
          ),
        );
      } else {
        var error = jsonDecode(response.body);
        handleErrors(error);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fejl ved oprettelse af bruger: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
    }
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

  late Future<User?> futureUser = Future.value(null);

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
              'Tilmeld dig herunder',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),
            CustomTextField(
                hintText: "Fornavn",
                controller: firstNameController,
                errorText: firstNameError),
            const SizedBox(height: 10),
            CustomTextField(
                hintText: "Efternavn",
                controller: lastNameController,
                errorText: lastNameError),
            const SizedBox(height: 10),
            CustomTextField(
                hintText: "Email",
                controller: emailController,
                errorText: emailError),
            const SizedBox(height: 10),
            CustomTextField(
                hintText: "Adgangskode",
                obscureText: true,
                controller: passwordController,
                errorText: passwordError),
            const SizedBox(height: 10),
            CustomTextField(
                hintText: "Gentag Adgangskode",
                obscureText: true,
                controller: confirmPasswordController,
                errorText: confirmPasswordError),
            const SizedBox(height: 10),
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
              mainColor: Colors.blue,
            ),
          ],
        ),
      )),
    );
  }
}
