import 'package:flutter/material.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class UnauthorizedPage extends StatelessWidget {
  const UnauthorizedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Egebakkeskolens\n Foodplanner',
            textAlign: TextAlign.center, style: AppTextStyles.title),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/logo.png'),
              opacity: 0.3,
              fit: BoxFit.contain,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Afventer godkendelse',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.title,
                ),
                SizedBox(height: 20),
                Text(
                  'Din bruger afventer godkendelse\n fra administrator',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bigText.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: CustomButton(
                      onTab: () async {
                        final authProvider =
                            Provider.of<AuthProvider>(context, listen: false);
                        await authProvider.logout();
                        context.go('/login');
                      },
                      text: "Log ud"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
