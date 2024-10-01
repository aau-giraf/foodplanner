import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/text_field.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // Text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() {}
  void DirectSignUpPage(){}

  void _showButtonPressDialog(BuildContext context, String provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$provider Button Pressed!'),
        backgroundColor: Colors.black26,
        duration: const Duration(milliseconds: 400),
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
              SFIcons.sf_lock_shield_fill,
              fontSize: 100,
              fontWeight: FontWeight.w400,
            ),
            const SizedBox(height: 50),
            const Text(
              'Login herunder',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
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
                  Text("Glemt adgangskode?"),
                ],
              ),
            ),
            const SizedBox(height: 25),
            CustomButton(onTab: signUserIn),
            const SizedBox(height: 10),


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
              onTab: DirectSignUpPage,
              text: 'Sign Up',
              MainColor: Colors.blue,
            ),
          ],
        ),
      )),
    );
  }
}
