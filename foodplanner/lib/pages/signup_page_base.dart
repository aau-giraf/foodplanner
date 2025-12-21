/*import 'package:flutter/material.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/password_requirements.dart';
import 'package:foodplanner/components/text_field.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/user_service.dart';

class SignupPageBase extends StatefulWidget {
  final String title, buttonText;
  final Widget? selection;
  final Future<void> Function(Map<String, String>) onSubmit;
  static final UserService userService = UserService(apiUrl: ApiConfig.baseUrl);

  const SignupPageBase({
    super.key,
    required this.title,
    required this.buttonText,
    this.selection,
    required this.onSubmit,
  });

  @override
  State<SignupPageBase> createState() => SignupPageBaseState();
}

class SignupPageBaseState extends State<SignupPageBase> {
  // Variables for text field controllers 
  final firstNameController = TextEditingController(), 
        lastNameController = TextEditingController(),
        emailController = TextEditingController(),
        passwordController = TextEditingController(),
        confirmPasswordController = TextEditingController();

  // Focus nodes for each input field
  final FocusNode _firstNameFocus = FocusNode(),
                  _lastNameFocus = FocusNode(),
                  _emailFocus = FocusNode(),
                  _passwordFocus = FocusNode(),
                  _confirmPasswordFocus = FocusNode();

  // Boolean values for checking if text fields are active
  bool isFirstNameFocused = false,
       isLastNameFocused = false,
       isEmailFocused = false,
       isPasswordFocused = false,
       isConfirmPasswordFocused = false;

  // Regular expressions for validating full name and email
  final RegExp nameRegExp = RegExp(r'^[a-z A-ZæøåÆØÅ]+$'),
              emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+$');

  // Regular expressions for password requirements
  final RegExp upperCase = RegExp(r'[A-ZÆØÅ]'),
              lowerCase = RegExp(r'[a-zæøå]'),
              digit = RegExp(r'\d');

  // Map for keeping track of password requirements
  Map<String, bool> passwordValidationStatus = {
    'hasUpperAndLowerCase': false,
    'hasDigit': false,
    'hasLength': false,
  };

  // Text error messages
  String firstNameError = '',
        lastNameError = '',
        emailError = '',
        passwordError = '',
        confirmPasswordError = '';

  // Getter for checking if any of the fields have an error    
  bool get hasError {
    return firstNameError.isNotEmpty ||
    lastNameError.isNotEmpty ||
    emailError.isNotEmpty ||
    passwordError.isNotEmpty ||
    confirmPasswordError.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();

    //Added listener for checking if the user is active in input fields
    _firstNameFocus.addListener(_onFocusChange);
    _lastNameFocus.addListener(_onFocusChange);
    _emailFocus.addListener(_onFocusChange);
    _passwordFocus.addListener(_onFocusChange);
    _confirmPasswordFocus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _firstNameFocus.removeListener(_onFocusChange);
    _lastNameFocus.removeListener(_onFocusChange);
    _emailFocus.removeListener(_onFocusChange);
    _passwordFocus.removeListener(_onFocusChange);
    _confirmPasswordFocus.removeListener(_onFocusChange);

    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  // Changing current state based on which input field is active
  void _onFocusChange() {
    setState(() {
      isFirstNameFocused = _firstNameFocus.hasFocus;
      isLastNameFocused = _lastNameFocus.hasFocus;
      isEmailFocused = _emailFocus.hasFocus;
      isPasswordFocused = _passwordFocus.hasFocus;
      isConfirmPasswordFocused = _confirmPasswordFocus.hasFocus;
    });
  }

  // Validating if name complies with regular expression
  void validateName(String name, String field){
    String errorMessage = '';
    if (!nameRegExp.hasMatch(name) && name.isNotEmpty) {
      errorMessage = 'Dit navn må kun indholde bogstaver.';
    }
    setState(() {
      if (field == 'first'){
        firstNameError = errorMessage;
      } else if (field == 'last'){
        lastNameError = errorMessage;
      }
    });
  }

  // Validating if email complies with regular expression
  void validateEmail(String email){
    setState(() {
      if (!emailRegExp.hasMatch(email) && email.isNotEmpty) {
        emailError = 'Det er ikke en gyldig email.';
      } else {
        emailError = '';
      }
    });
  }

  // Validate if content in password complies with requirements
  void validatePasswordRequirements(String password){
    setState(() {
      // Initialization of variables for dynamic update of requirements in list
      passwordValidationStatus['hasUpperAndLowerCase'] = (password.contains(upperCase) && password.contains(lowerCase));
      passwordValidationStatus['hasDigit'] = password.contains(digit);
      passwordValidationStatus['hasLength'] = (password.length > 7 && password.length < 31);

      // Logic for handling error
      if (password.isNotEmpty && (!password.contains(upperCase) || !password.contains(lowerCase) ||
        !password.contains(digit) || password.length < 8 ||
        password.length > 30)) {
          passwordError = 'Adgangskoden overholder ikke alle krav.';
      } else {
        passwordError = '';
      }
    });
  }

  // Validate the input field for confirming password
  void validateConfirmPassword(String password, String confirmPassword){
    setState(() {
      if (password != confirmPassword && confirmPassword.isNotEmpty) {
        confirmPasswordError = 'Adgangskoderne matcher ikke.';
      } else {
        confirmPasswordError = '';
      }
    });
  }

  // Function for updating error message for password and confirm password dynamically 
  void validatePassword(String password, String confirmPassword){
    validatePasswordRequirements(password);
    validateConfirmPassword(password, confirmPassword);
  }

  //Function to validate all form inputs before signing user up
  void validateAllInputs(BuildContext context) {
    String firstName = firstNameController.text.trim();
    String lastName = lastNameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    validateName(firstName, 'first');
    validateName(lastName, 'last');
    validateEmail(email);
    validatePassword(password, confirmPassword);

    if (hasError){
      return;
    }

    final data = {
      "firstName": firstNameController.text,
      "lastName": lastNameController.text,
      "email": emailController.text,
      "password": passwordController.text,
    };

    widget.onSubmit(data);
  }

  void handleErrors(Map<String, dynamic> error) {
   setState(() {
    firstNameError = error['First_name'] != null ? error['First_name'][0] : '';
    lastNameError = error['Last_name'] != null ? error['Last_name'][0] : '';
    emailError = error['Email'] != null ? error['Email'][0] : '';
    passwordError = error['Password'] != null ? error['Password'][0] : '';
   });
  }

  // check if any of the input fields are empty
  bool fieldsNotEmpty() {

    List<String> req = [
      firstNameController.text,
      lastNameController.text,
      emailController.text,
      passwordController.text,
      confirmPasswordController.text,
    ];

    return req.every((e) => e.isNotEmpty);
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
                  Text(widget.title, style: AppTextStyles.title),
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
                      hintText: "Fornavn",
                      focusNode: _firstNameFocus,
                      onChanged: (input) => validateName(firstNameController.text, 'first') // Validate with every input change for dynamic error messaging
                    ),
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
                      hintText: "Efternavn",
                      focusNode: _lastNameFocus,
                      onChanged: (input) => validateName(lastNameController.text, 'last')
                    ),
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
                      errorText: isEmailFocused ? '' : emailError, // only show error when user is not active in field
                      hintText: "Email",
                      focusNode: _emailFocus,
                      onChanged: (input) => validateEmail(emailController.text) 
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Adgangskode',
                    style: AppTextStyles.bigText
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column( // A column holding both the text field and the list of requirements for password
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomTextField(
                          controller: passwordController,
                          errorText: isPasswordFocused ? '' : passwordError, // hide error message if user is active in password field
                          hintText: "Adgangskode",
                          obscureText: true, 
                          focusNode: _passwordFocus,
                          onChanged: (input) => validatePassword(passwordController.text, confirmPasswordController.text) 
                        ),
                        if (isPasswordFocused) // only show list of password requirements if user is active in password field
                          PasswordRequirements(
                            validationStatus: passwordValidationStatus,
                          ),  
                      ],
                    ),
                  ),
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
                      errorText: confirmPasswordController.text.isEmpty ? '' : confirmPasswordError, // only show error if field is not empty
                      hintText: "Adgangskode",
                      obscureText: true,
                      focusNode: _confirmPasswordFocus,
                      onChanged: (input) => validatePassword(passwordController.text, confirmPasswordController.text) 
                    ),
                  ),
                  SizedBox(height: 15),
                  if (widget.selection != null) widget.selection!,
                ],
              ),
            ),
            SizedBox(height: 10),
            CustomButton(
              text: widget.buttonText,
              onTab: fieldsNotEmpty() && !hasError ? () => validateAllInputs(context) : null, // if fields are not empty and none has an error, activate the button for signing up
            ),
          ],
        ),
      ),
    );
  }
}*/
