import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/text_field.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // Text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() {}
  void directSignUpPage() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            const SizedBox(height: 100),
            const SFIcon(
              SFIcons.sf_lock_shield_fill,
              fontSize: 100,
              fontWeight: FontWeight.w400,
            ),
            const SizedBox(height: 50),
            const Text(
              'Login herunder',
              style: AppTextStyles.headline1,
            ),
            const SizedBox(height: 25),
            CustomTextField(
                hintText: "Brugernavn", controller: usernameController),
            const SizedBox(height: 15),
            CustomTextField(
                hintText: "Adgangskode",
                obscureText: true,
                controller: passwordController),
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
            CustomButton(onTab: signUserIn),
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
              onTab: directSignUpPage,
              text: 'Opret bruger',
              mainColor: AppColors.secondary,
            ),
          ],
        ),
      )),
    );
  }
}
