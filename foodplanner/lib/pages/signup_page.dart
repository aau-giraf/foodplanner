import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/text_field.dart';
import 'package:foodplanner/components/Strengthbar.dart';


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

  //Regular expression for vildationg full name, Email, password¨
  final RegExp nameRegExp = RegExp(r'^[a-zA-ZæøåÆØÅ\s]+$');
  final RegExp emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
  final RegExp passwordLowercaseRegExp = RegExp(r'[a-zæøå]');
  final RegExp passwordUppercaseRegExp = RegExp(r'[A-ZÆØÅ]');
  final RegExp passwordDigitRegExp = RegExp(r'\d');
  final RegExp passwordSpecialCharRegExp = RegExp(r'[!@#\$&£%*~]');

  // Password strength score
  double passwordStrength = 0;

  //Function to validate form inputs
  void validateInputs(BuildContext context) {
    String firstName = firstNameController.text.trim();
    String lastName = lastNameController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    String email = emailController.text.trim();
    
    // Step 1: Check if all fields are filled
    if (firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      showErrorSnackbar(context, 'Alle felter skal være udfyldt.');
      return; // Stop if there's an error
    }

    // Step 2: Name Validation
    if (!nameRegExp.hasMatch(firstName)) {
      showErrorSnackbar(context, 'Dit navn må kun indhold bogstaver');
      return; // Stop if there's an error
    }

    if (!nameRegExp.hasMatch(lastName)) {
      showErrorSnackbar(context, 'Dit navn må kun indhold bogstaver');
      return; // Stop if there's an error
    }

    // Step 3: Email Validation
    if (!emailRegExp.hasMatch(email)) {
      showErrorSnackbar(context, 'Det er ikke en gyldig email');
      return; // Stop if there's an error
    }

    // Step 4: Password Validation
    if (!validatePassword(context, password)) {
      return; // Stop if there's an error in password validation
    }

    // Step 5: Confirm Password Validation
    if (password != confirmPassword) {
      showErrorSnackbar(context, 'Adgangskode passer ikke');
      return; // Stop if passwords do not match
    }

    // Proceed with sign-up logic if everything is correct
    signUserUp(context);
  }

  // Function to validate password
  bool validatePassword(BuildContext context, String password) {
    // Check for at least one lowercase letter
    if (!passwordLowercaseRegExp.hasMatch(password)) {
      showErrorSnackbar(context, 'Adgangskode skal indholde mindst ét lille bogstav.');
      return false; // Indicate an error
    }

    // Check for at least one uppercase letter
    if (!passwordUppercaseRegExp.hasMatch(password)) {
      showErrorSnackbar(context, 'Adgangskode skal indholde mindst ét stort bogstav.');
      return false; // Indicate an error
    }

    // Check for at least one digit
    if (!passwordDigitRegExp.hasMatch(password)) {
      showErrorSnackbar(context, 'Adgangskode skal indholde mindst ét tal.');
      return false; // Indicate an error
    }

    // Check if the length is at least 8 characters
    if (password.length < 8) {
      showErrorSnackbar(context, 'Adgangskode skal være mindst 8 tegn lang.');
      return false; // Indicate an error
    }

    // Check if the length does not exceed 30 characters
    if (password.length > 30) {
      showErrorSnackbar(context, 'Adgangskode må ikke overstige 30 tegn.');
      return false; // Indicate an error
    }

    return true; // No errors found
  }

  // Function to calculate password strength
  double calculatePasswordStrength(String password) {
    int strength = 0;

    if (password.length >= 8) strength++; // Basic length requirement
    if (password.length >= 12) strength++; 
    if (password.length >= 16) strength++; 
    if (passwordLowercaseRegExp.hasMatch(password)) strength++; // Contains lowercase
    if (passwordUppercaseRegExp.hasMatch(password)) strength++; // Contains uppercase
    if (passwordDigitRegExp.hasMatch(password)) strength++; // Contains digit
    if (passwordSpecialCharRegExp.hasMatch(password)) strength++; // Contains special character

    return (strength / 7).clamp(0, 1); // Return value between 0 and 1
  }
  
  // Helper method to show error messages in a snackbar
  void showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
      ),
    );
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
                hintText: "Fornavn", controller: firstNameController),
            const SizedBox(height: 15),
            CustomTextField(
                hintText: "Efternavn", controller: lastNameController),
            const SizedBox(height: 15),
            CustomTextField(
                hintText: "Email", controller: emailController),
            const SizedBox(height: 15),
        
            // Password field with strength bar
              StrengthBar(
                hintText: "Adgangskode",
                obscureText: true,
                controller: passwordController,
                onChanged: (value) {
                  setState(() {
                    passwordStrength = calculatePasswordStrength(value);
                  });
                },
              ),
              const SizedBox(height: 5),

              // Password Strength Bar
              PasswordStrengthBar(strength: passwordStrength),

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
        
            const SizedBox(height: 25),
            CustomButton(
              onTab: () => validateInputs(context),
              text: 'Tilmeld dig',
              MainColor: Colors.blue,
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 150),
              child: Divider(
                color: Colors.black,
                thickness: 2,
              ),
            ),
            const SizedBox(height: 15),
            CustomButton(
              onTab: () => validateInputs(context),
              text: 'Har allerede en bruger',
              MainColor: Colors.blue,
            ),
          ],
        ),
      )),
    );
  }
}

