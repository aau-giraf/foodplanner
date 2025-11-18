import 'package:flutter/material.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/text_field.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/models/user.dart';
import 'package:foodplanner/pages/signup_page_adult.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/pages/forgot_password_page.dart';
import 'signup_page.dart';
import 'package:foodplanner/services/fetch_auth.dart';
import 'package:go_router/go_router.dart';
import '../routes/user_roles.dart';

//test push
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static final AuthService authService = AuthService(apiUrl: ApiConfig.baseUrl);

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
    if (error['Message'] != null) {
      updateErrorState('Email', ' ');
      updateErrorState('Password', error['Message'][0]);
    } else {
      updateErrorState(
          'Email', error['Email'] != null ? error['Email'][0] : '');
      updateErrorState(
          'Password', error['Password'] != null ? error['Password'][0] : '');
    }
  }

  void signUserIn(BuildContext context) async {
    if(usernameController.text.isEmpty && passwordController.text.isEmpty){
      setState(() {
        emailError = 'Email mangler';
        passwordError = 'Adgangskode mangler';
      });

    } else if (usernameController.text.isEmpty){
      setState(() {
        emailError  = 'Email mangler';
        passwordError = '';
      });

    }else if(passwordController.text.isEmpty){
      setState(() {
        emailError = '';
        passwordError = 'Adgangskode mangler';
      });
    } else {
      setState(() {
        emailError = '';
        passwordError = '';
      });
    }
    try {
      final role = await LoginPage.authService
          .fetchAuthData(usernameController.text, passwordController.text);
      switch (role) {
      case ROLES.teacher:
        GoRouter.of(context).go(TEACHER_ROOT);
        break;
      case ROLES.student:
        GoRouter.of(context).go(STUDENT_ROOT);
        break;
      case ROLES.admin:
        GoRouter.of(context).go(ADMIN_ROOT);
        break;
      case ROLES.parent:
        GoRouter.of(context).go(PARENT_ROOT);
        break;
      default:
        GoRouter.of(context).go(LOGIN_PAGE);
        break;
    }
  }
    catch (e) {
      if (e is AuthException) {
        handleErrors({'Message': [e.message]});
      } else if (e is NetworkException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Der opstod et problem ved login: ${e.message}'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 6),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Der opstod et ukendt problem ved login: $e'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 6),
          ),
        );
      }
    }
  }

  void loginInpage() {}

  void directSignUpPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignupPageAdult(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Egebakkeskolen\nFoodplanner',
          style: AppTextStyles.title,
          textAlign: TextAlign.center,
        ),
      ),
       body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
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
                  elevation: 3,
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      Text(
                        'Log ind',
                        style: AppTextStyles.headline3.copyWith(fontSize: 22),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'Email',
                        style: AppTextStyles.headline4.copyWith(fontSize: 18),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: CustomTextField(
                            hintText: "Email",
                            controller: usernameController,
                            errorText: emailError),
                      ),
                      const SizedBox(height: 50),
                      Text(
                        'Adgangskode',
                        style: AppTextStyles.headline4.copyWith(fontSize: 18),
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
                                        builder: (context) =>
                                            ForgotPasswordPage()),
                                  );
                                },
                                child: Text(
                                  "Glemt adgangskode?",
                                  style: AppTextStyles.standard.copyWith(
                                    color: AppColors.secondary,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.secondary,
                                    fontSize: 14,
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
                        text: 'Opret',
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
}
