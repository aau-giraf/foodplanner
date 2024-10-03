import 'package:flutter/material.dart';
import 'package:foodplanner/components/text_field.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/button.dart';
import 'package:validators/validators.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  String? errorMessage;

  void validateEmail() {
    setState(() {
      if (isEmail(emailController.text)) {
        errorMessage = null;
        // Proceed with sending the email
      } else {
        errorMessage = 'Indtast en gyldig email';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 100),
            SFIcon(
              SFIcons.sf_envelope_badge_shield_half_filled_fill,
              fontSize: 100,
              fontWeight: FontWeight.w400,
            ),
            SizedBox(height: 50),
            Text(
              'Indtast din email, så sender vi et nyt kodeord',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 25),
            CustomTextField(
              hintText: "Email",
              controller: emailController,
            ),
            SizedBox(height: 10),
            CustomButton(
              onTab: validateEmail,
              text: 'Send email',
              MainColor: Colors.blue,
            ),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
