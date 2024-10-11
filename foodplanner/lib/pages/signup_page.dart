import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/segment_button.dart';
import 'package:foodplanner/components/text_field.dart';
import 'package:foodplanner/components/user.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

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

  Set<String> role = {'Parent'};

  List<ButtonSegment<String>> segments = [
    ButtonSegment(
      value: 'Parent',
      label: Text('Forældre'),
      icon: SFIcon(SFIcons.sf_figure_and_child_holdinghands),
    ),
    ButtonSegment(
      value: 'Teacher',
      label: Text('Lærer'),
      icon: SFIcon(SFIcons.sf_graduationcap_fill),
    ),
  ];

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

  void roleChange(Set<String> value) {
    setState(() {
      role = value;
    });
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
    signUserUp(
        context, firstName, lastName, email, password, confirmPassword, role);
  }

  //Placeholder function for sign-up logic
  void signUserUp(
      BuildContext context,
      String firstName,
      String lastName,
      String email,
      String password,
      String confirmPassword,
      Set<String> role) async {
    try {
      final response =
          await createUser(firstName, lastName, email, password, role.first);

      if (!context.mounted) return;

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
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fejl ved oprettelse af bruger: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  bool showButton() {
    return firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Egebakkeskolen\nFoodplanner',
          style: AppTextStyles.title,
          textAlign: TextAlign.center,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              color: AppColors.background,
              surfaceTintColor: AppColors.background,
              elevation: 3,
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Text('Opret mig', style: AppTextStyles.title),
                  SizedBox(height: 10),
                  Text(
                    'Fornavn',
                    style: AppTextStyles.bigText
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomTextField(
                        controller: firstNameController,
                        errorText: firstNameError,
                        hintText: "Fornavn"),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Efternavn',
                    style: AppTextStyles.bigText
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomTextField(
                        controller: lastNameController,
                        errorText: lastNameError,
                        hintText: "Efternavn"),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Email',
                    style: AppTextStyles.bigText
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomTextField(
                        controller: emailController,
                        errorText: emailError,
                        hintText: "Email"),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Adgangskode',
                    style: AppTextStyles.bigText
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CustomTextField(
                          controller: passwordController,
                          errorText: passwordError,
                          hintText: "Adgangskode",
                          obscureText: true)),
                  SizedBox(height: 15),
                  Text(
                    'Bekræft adgangskode',
                    style: AppTextStyles.bigText
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomTextField(
                      controller: confirmPasswordController,
                      errorText: confirmPasswordError,
                      hintText: "Adgangskode",
                      obscureText: true,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Jeg er',
                    style: AppTextStyles.bigText
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomSegmentButton(
                      buttonSegments: segments,
                      selected: role,
                      onTab: roleChange,
                    ),
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),
            SizedBox(height: 10),
            CustomButton(
              text: 'Opret mig',
              onTab: showButton() ? () => validateInputs(context) : null,
            ),
          ],
        ),
      ),
    );
  }
}
