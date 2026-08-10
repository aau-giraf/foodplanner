import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/text_field.dart';
import 'package:foodplanner/models/schoolClass.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/pupil_service.dart';
import 'package:foodplanner/services/school_class_service.dart';
import 'package:go_router/go_router.dart';

class CreatePupilPage extends StatefulWidget {
  const CreatePupilPage({super.key});
  static final SchoolClassService schoolClassService =
      SchoolClassService(apiUrl: ApiConfig.baseUrl);
  static final PupilService childService =
      PupilService(apiUrl: ApiConfig.baseUrl);

  @override
  State<CreatePupilPage> createState() => _SignupChildState();
}

class _SignupChildState extends State<CreatePupilPage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Text error messages
  String firstNameError = '';
  String lastNameError = '';
  String emailError = '';
  String passwordError = '';

  //Regular expression for vildationg full name, Email, password¨
  final RegExp nameRegExp = RegExp(r'^[a-z A-ZæøåÆØÅ]+$');
  final RegExp emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
  final RegExp upperCase = RegExp(r'[A-ZÆØÅ]');
  final RegExp lowerCase = RegExp(r'[a-zæøå]');
  final RegExp digit = RegExp(r'\d');

  Future<List<SchoolClass>> classesFuture =
      CreatePupilPage.schoolClassService.fetchAllClasses();
  List<SchoolClass> classes = [];

  @override
  void initState() {
    super.initState();
    firstNameController.addListener(_updateButtonState);
    lastNameController.addListener(_updateButtonState);
    emailController.addListener(_updateButtonState);
    passwordController.addListener(_updateButtonState);
    classesFuture.then((classes) {
      setState(() {
        this.classes = classes;
      });
    });
  }

  @override
  void dispose() {
    firstNameController.removeListener(_updateButtonState);
    lastNameController.removeListener(_updateButtonState);
    emailController.removeListener(_updateButtonState);
    passwordController.removeListener(_updateButtonState);
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
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
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    int selectedClassId =
        selectedValue!.isNotEmpty ? int.parse(selectedValue!) : 0;
    //Step 1: Check om alle felter er udfyldt
    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      // Show an error message if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Alle felter skal være udfyldt.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
      return;
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
        emailError = 'Det er ikke en gyldig email.';
      });
      return;
    } else {
      setState(() {
        emailError = '';
      });
    }

    //Step 4: Password Validation
    if (!password.contains(upperCase) ||
        !password.contains(lowerCase) ||
        !password.contains(digit) ||
        password.length < 8 ||
        password.length > 30) {
      setState(() {
        passwordError = 'Adgangskoden overholder ikke alle krav.';
      });
      return;
    } else {
      setState(() {
        passwordError = '';
      });
    }

    //proceed with sign-up logic if everything is correct
    createChildHandler(
        context, firstName, lastName, email, password, selectedClassId);
  }

  //Placeholder function for sign-up logic
  void createChildHandler(
    BuildContext context,
    String firstName,
    String lastName,
    String email,
    String password,
    int classId,
  ) async {
    try {
      final response = await CreatePupilPage.childService
          .createPupil(firstName, lastName, email, password, classId);

      if (!context.mounted) return;

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Barn oprettet!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 5),
          ),
        );
        context.go('/');
      } else if (response.body.isEmpty) {
        // Guard against an empty body (nothing to decode).
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Barn kunne ikke oprettes.'),
            backgroundColor: Colors.red,
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
          content: Text('Fejl ved oprettelse af barn: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  String? selectedValue;

  bool showButton() {
    return firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        selectedValue != null;
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
      body: SingleChildScrollView(
        child: Padding(
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
                          obscureText: true,
                          hintText: "Adgangskode"),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Klasse',
                      style: AppTextStyles.bigText
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: Text(
                            'Vælg klasse',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          items: classes
                              .map((SchoolClass schoolClass) =>
                                  DropdownMenuItem<String>(
                                    value: schoolClass.classId.toString(),
                                    child: Text(
                                      schoolClass.className,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                              .toList(),
                          value: selectedValue,
                          onChanged: (String? value) {
                            setState(() {
                              selectedValue = value;
                            });
                          },
                          selectedItemBuilder: (BuildContext context) {
                            return classes.map((SchoolClass schoolClass) {
                              return Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  schoolClass.className,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList();
                          },
                          buttonStyleData: ButtonStyleData(
                            height: 50,
                            width: 200,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: AppColors.primary,
                            ),
                            elevation: 2,
                          ),
                          iconStyleData: const IconStyleData(
                            icon: SFIcon(
                              SFIcons.sf_chevron_forward,
                            ),
                            openMenuIcon: SFIcon(
                              SFIcons.sf_chevron_down,
                            ),
                            iconSize: 16,
                            iconEnabledColor: AppColors.textSecondary,
                            iconDisabledColor: Colors.grey,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 200,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: AppColors.background,
                            ),
                            scrollbarTheme: ScrollbarThemeData(
                              radius: const Radius.circular(40),
                              thickness: WidgetStatePropertyAll<double>(6),
                              thumbVisibility:
                                  WidgetStatePropertyAll<bool>(true),
                            ),
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              SizedBox(height: 15),
              CustomButton(
                text: 'Registrer barn',
                onTab: showButton() ? () => validateInputs(context) : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
