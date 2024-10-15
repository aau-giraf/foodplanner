import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/text_field.dart';
import 'package:foodplanner/components/user.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'forgot_password_page.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  // Text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // Text error messages
  String emailError = '';
  String passwordError = '';

  void updateErrorState(String field, String error) {
    setState(() {
      switch (field) {
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
    updateErrorState('Email', error['Email'] != null ? error['Email'][0] : '');
    updateErrorState(
        'Password', error['Password'] != null ? error['Password'][0] : '');
  }

  void signUserIn(BuildContext context) async {
    try {
      final response =
          await loginUser(usernameController.text, passwordController.text);

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        User user = User.fromJson(body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Du er nu logget ind. ${user.firstName}, ${user.lastName}'),
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
          content: Text('Der opstod et problem ved login: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  void loginInpage() {}

  void directSignUpPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Signup(),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Text(
              'Egebakkeskolen',
              style: AppTextStyles.headline2
                .copyWith(fontSize: 26),
            ),
            const SizedBox(height: 5),
            Text(
              'Foodplanner',
              style: AppTextStyles.headline2
                .copyWith(fontSize: 26),
            ),
            const SizedBox(height: 35),
            Image(
              image: AssetImage('assets/images/logo.png'),
              height: 160,
            ),
            const SizedBox(height: 35),
            Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  color: AppColors.background,
                  surfaceTintColor: AppColors.background,
                  elevation:  3,
                    child: Column(
                      children: [
                        const SizedBox(height: 15),
                        Text(
                          'Log ind',
                          style: AppTextStyles.headline3
                              .copyWith(fontSize: 22),                         
                        ),
                        const SizedBox(height: 30),
                        Text(
                          'Brugernavn',
                          style: AppTextStyles.headline4
                              .copyWith(fontSize: 18),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: CustomTextField(
                            hintText: "Brugernavn",
                            controller: usernameController,
                            errorText: emailError),
                        ),
                        const SizedBox(height: 50),
                        Text(
                          'Adgangskode',
                          style: AppTextStyles.headline4
                              .copyWith(fontSize: 18),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: CustomTextField(
                            hintText: "Adgangskode",
                            obscureText: true,
                            controller: passwordController,
                            errorText: passwordError),
                        ),
                        const SizedBox(height: 25),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Flexible(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ForgotPasswordPage()),
                                    );
                                  },
                                  child: Text(
                                    "Glemt adgangskode?",
                                    style: AppTextStyles.standard.copyWith(
                                      color: AppColors.secondary,
                                      decoration: TextDecoration.underline,
                                      decorationColor: AppColors.secondary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
                      ],
                    ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(  
                      child: CustomButton(
                        onTab: () => directSignUpPage(context),
                        text: 'Tilbage',
                        backgroundColor: AppColors.secondary,
                      ),
                    ),  
                    SizedBox(width: 15),
                    Expanded(
                      child: CustomButton(
                        text: "Login",
                        onTab: () => signUserIn(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }



 /* @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            const SizedBox(height: 300),
            Image(
              image: AssetImage('assert/images/logo.png'),
              width: 300,
              height: 300,
            ),
            const SizedBox(height: 50),
            const Text(
              'Login herunder',
              style: AppTextStyles.headline1,
            ),
            const SizedBox(height: 25),
            CustomTextField(
                hintText: "Brugernavn",
                controller: usernameController,
                errorText: emailError),
            const SizedBox(height: 15),
            CustomTextField(
                hintText: "Adgangskode",
                obscureText: true,
                controller: passwordController,
                errorText: passwordError),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 150),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPasswordPage()),
                      );
                    },
                    child: Text(
                      "Glemt adgangskode?",
                      style: AppTextStyles.standard.copyWith(
                        color: AppColors.secondary,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            CustomButton(
              text: "Login",
              onTab: () => signUserIn(context),
            ), // Wrap in anonymous function
            const SizedBox(height: 10),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 150),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.black,
                      thickness: 2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: const Text(
                      "ELLER",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.black,
                      thickness: 2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            CustomButton(
              onTab: () => directSignUpPage(context),
              text: 'Opret bruger',
              backgroundColor: AppColors.secondary,
            ),
          ],
        ),
      )),
    );
  }*/
}
