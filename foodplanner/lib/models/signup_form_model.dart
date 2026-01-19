import 'package:flutter/material.dart';

class SignupFormModel {
  // Variables for text field controllers 
  final firstNameController = TextEditingController(); 
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Focus nodes for each input field
  final FocusNode firstNameFocus = FocusNode();
  final FocusNode lastNameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode confirmPasswordFocus = FocusNode();

  // Regular expressions for validating full name and email
  final RegExp nameRegExp = RegExp(r'^[a-z A-ZæøåÆØÅ]+$');
  final RegExp emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+$');

  // Regular expressions for password requirements
  final RegExp upperCase = RegExp(r'[A-ZÆØÅ]');
  final RegExp lowerCase = RegExp(r'[a-zæøå]');
  final RegExp digit = RegExp(r'\d');

  // Text error messages
  String firstNameError = '';
  String lastNameError = '';
  String emailError = '';
  String passwordError = '';
  String confirmPasswordError = '';

  // Map for keeping track of password requirements
  Map<String, bool> passwordValidationStatus = {
    'hasUpperAndLowerCase': false,
    'hasDigit': false,
    'hasLength': false,
  };

  // Validating if firstName complies with regular expression
  void validateFirstName(){
    final input = firstNameController.text.trim();
    if (input.isNotEmpty && !nameRegExp.hasMatch(input)) {
    firstNameError = 'Dit navn må kun indeholde bogstaver.';
    } else {
      firstNameError = '';
    }
  }

  // Validating if firstName complies with regular expression
  void validateLastName(){
    final input = lastNameController.text.trim();
    if (input.isNotEmpty && !nameRegExp.hasMatch(input)) {
      lastNameError = 'Dit navn må kun indeholde bogstaver.';
    } else {
      lastNameError = '';
    }
  }

  // Validating if email complies with regular expression
  void validateEmail(){
    final email = emailController.text.trim();

    if(email.isNotEmpty && !emailRegExp.hasMatch(email)) {
      emailError = 'Det er ikke en gyldig email.';
    } else {
      emailError = '';
    }
  }

  // Validate if content in password complies with requirements
  void validatePassword(){

    final password = passwordController.text.trim();

    // Initialization of variables for dynamic update of requirements in list
    passwordValidationStatus['hasUpperAndLowerCase'] = (password.contains(upperCase) && password.contains(lowerCase));
    passwordValidationStatus['hasDigit'] = password.contains(digit);
    passwordValidationStatus['hasLength'] = (password.length > 7 && password.length < 31);

    // Logic for handling error
    if (password.isNotEmpty && 
        (!password.contains(upperCase) || 
         !password.contains(lowerCase) ||
         !password.contains(digit) || 
         password.length < 8 ||
         password.length > 30)) {
      passwordError = 'Adgangskoden overholder ikke alle krav.';
    } else {
      passwordError = '';
    }
  }

  // Validate the input field for confirming password
  void validateConfirmPassword(){
    final password = passwordController.text.trim();
    final confirm = confirmPasswordController.text.trim();

    if(confirm.isNotEmpty && password != confirm) {
      confirmPasswordError = 'Adgangskoderne matcher ikke.';
    } else {
      confirmPasswordError = '';
    }
  }

  //Function to validate all form inputs before signing user up
  void validateAll() {
    validateFirstName();
    validateLastName();
    validateEmail();
    validatePassword();
    validateConfirmPassword();
  }

  // Getter for checking if any of the fields have an error    
  bool get hasError {
    return firstNameError.isNotEmpty ||
    lastNameError.isNotEmpty ||
    emailError.isNotEmpty ||
    passwordError.isNotEmpty ||
    confirmPasswordError.isNotEmpty;
  }

  bool get fieldsNotEmpty {
    return firstNameController.text.isNotEmpty &&
    lastNameController.text.isNotEmpty &&
    emailController.text.isNotEmpty &&
    passwordController.text.isNotEmpty &&
    confirmPasswordController.text.isNotEmpty;
  }

  Map<String, String> get formData {
    return {
      "firstName": firstNameController.text,
      "lastName": lastNameController.text,
      "email": emailController.text,
      "password": passwordController.text,
    };
  }

  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    firstNameFocus.dispose();
    lastNameFocus.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    confirmPasswordFocus.dispose();
  }
}