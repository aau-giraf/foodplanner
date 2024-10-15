import 'package:flutter/material.dart';
import 'package:foodplanner/components/apple_sign_in.dart';
import 'package:foodplanner/config/text_styles.dart';

class LoginStart extends StatelessWidget {
  const LoginStart({super.key});

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
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 35),
              Image(
                image: AssetImage('assets/images/logo.png'),
                height: 180,
              ),
              SizedBox(height: 35),
              Text(
                'Log ind med',
                style: AppTextStyles.headline3,
                textAlign: TextAlign.center,
              ),
              AppleSignInButton(),
            ],
          ),
        ));
  }
}
