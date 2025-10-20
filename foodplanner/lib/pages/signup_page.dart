import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/segment_button.dart';
import 'package:foodplanner/components/text_field.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/pages/login_page.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:foodplanner/routes/user_roles.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/fetch_auth.dart';
import 'package:foodplanner/services/user_service.dart';
import 'package:go_router/go_router.dart';
import 'package:foodplanner/components/password_requirements.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  static final UserService userService = UserService(apiUrl: ApiConfig.baseUrl);

  @override
  State<SignupPage> createState() => _SignupState();
}

class _SignupState extends State<SignupPage> {

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

  // Regular expressions for validating full name, email, and password
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

  void roleChange(Set<String> value) {
    setState(() {
      role = value;
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
    bool hasError = false;

    validateName(firstName, 'first');
    validateName(lastName, 'last');
    validateEmail(email);
    validatePassword(password, confirmPassword);

    //proceed with sign-up logic if every input is validated
    if(!hasError) {
      signUserUp(
        context, firstName, lastName, email, password, confirmPassword, role);
    }
  }

  void handleErrors(Map<String, dynamic> error) {
   setState(() {
    firstNameError = error['First_name'] != null ? error['First_name'][0] : '';
    lastNameError = error['Last_name'] != null ? error['Last_name'][0] : '';
    emailError = error['Email'] != null ? error['Email'][0] : '';
    passwordError = error['Password'] != null ? error['Password'][0] : '';
   });
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
      final response = await SignupPage.userService
          .createUser(firstName, lastName, email, password, role.first);

      if (!context.mounted) return;

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bruger oprettet!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 5),
          ),
        );
        try {
          final role =
              await LoginPage.authService.fetchAuthData(email, password);
          switch (role) {
            case ROLES.student:
              GoRouter.of(context).go(STUDENT_CREATE);
              break;
            default:
              GoRouter.of(context).go(UNAUTHORIZED);
              break;
          }
        } catch (e) {
          if (e is AuthException) {
            handleErrors({
              'Message': [e.message]
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Fejl ved login af bruger: ${e.message}'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 5),
              ),
            );
          } else {
            if (role.first == 'Parent') {
              context.go('/signup/create-child');
            } else {
              context.go('/');
            }
          }
        }
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

  // check if any of the input fields are empty
  bool fieldsNotEmpty() {
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
              onTab: fieldsNotEmpty() && !hasError ? () => validateAllInputs(context) : null, // if fields are not empty and none has an error, activate the button for signing up
            ),
          ],
        ),
      ),
    );
  }
}