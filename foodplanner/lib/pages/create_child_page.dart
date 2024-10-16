import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/segment_button.dart';
import 'package:foodplanner/components/text_field.dart';
import 'package:foodplanner/components/user.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';

class CreateChildPage extends StatefulWidget {
  const CreateChildPage({super.key});

  @override
  State<CreateChildPage> createState() => _SignupChildState();
}

class _SignupChildState extends State<CreateChildPage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  // Text error messages
  String firstNameError = '';
  String lastNameError = '';

  //Regular expression for vildationg full name, Email, password¨
  final RegExp nameRegExp = RegExp(r'^[a-z A-ZæøåÆØÅ]+$');

  @override
  void initState() {
    super.initState();
    firstNameController.addListener(_updateButtonState);
    lastNameController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    firstNameController.removeListener(_updateButtonState);
    lastNameController.removeListener(_updateButtonState);
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {});
  }

  void updateErrorState(String field, String error) {
    setState(() {
      switch (field) {
        case 'First_name':
          firstNameError = error;
          break;
        case 'Last_name':
          lastNameError = error;
          break;
      }
    });
  }

  void handleErrors(Map<String, dynamic> error) {
    updateErrorState('First_name',
        error['First_name'] != null ? error['First_name'][0] : '');
    updateErrorState(
        'Last_name', error['Last_name'] != null ? error['Last_name'][0] : '');
  }

  //Function to validate form inputs
  void validateInputs(BuildContext context) {
    String firstName = firstNameController.text.trim();
    String lastName = lastNameController.text.trim();
    //Step 1: Check om alle felter er udfyldt
    if (firstName.isEmpty || lastName.isEmpty) {
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

    //proceed with sign-up logic if everything is correct
    //createChild(context, firstName, lastName);
  }

  //Placeholder function for sign-up logic
  /* void createChild(
      BuildContext context, String firstName, String lastName) async {
    try {
      final response = await createChild(firstName, lastName);

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
  } */

  bool showButton() {
    return firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty;
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
                  Text('Registrer barn', style: AppTextStyles.title),
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
                    'Klasse',
                    style: AppTextStyles.bigText
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),
            SizedBox(height: 10),
            CustomButton(
              text: 'Registrer barn',
              onTab: showButton() ? () => validateInputs(context) : null,
            ),
          ],
        ),
      ),
    );
  }
}
