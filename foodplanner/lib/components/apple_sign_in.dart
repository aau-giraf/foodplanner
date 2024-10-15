import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleSignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SignInWithAppleButton(
      onPressed: () async {
        try {
          final AuthorizationCredentialAppleID result =
              await SignInWithApple.getAppleIDCredential(
            scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
            webAuthenticationOptions: WebAuthenticationOptions(
              clientId: 'com.giraf.foodplanner.apple.sign.in',
              redirectUri: Uri.parse(''),
            ),
          );

          print(result);
          // You can use the result to authenticate the user with your server.
        } catch (error) {
          print(error.toString());
        }
      },
    );
  }
}
