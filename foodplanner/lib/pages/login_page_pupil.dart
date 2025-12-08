import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/api/openapi/lib/api.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/text_field.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/navigation/navbar_strategy_mapper.dart';
import 'package:foodplanner/pages/signup_page_adult.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/pages/forgot_password_page.dart';
import 'package:foodplanner/services/pupil_service.dart';
import 'package:foodplanner/services/user_service.dart';
import 'package:http/http.dart';
import 'signup_page.dart';
import 'package:foodplanner/services/fetch_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:foodplanner/models/user_roles.dart';

//test push
class LoginPagePupil extends StatefulWidget {
  const LoginPagePupil({super.key});
  static final AuthService authService = AuthService(apiUrl: ApiConfig.baseUrl);

  @override
  LoginPagePupilState createState() => LoginPagePupilState();
}

class LoginPagePupilState extends State<LoginPagePupil> {
  late double customButtonHeight = MediaQuery.of(context).size.height * 0.08;
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
    // print("Pressed");

    PupilService pupilService = PupilService(apiUrl: ApiConfig.baseUrl);
    UserService userService = UserService(apiUrl: ApiConfig.baseUrl);
    
  
  
    // if(usernameController.text.isEmpty && passwordController.text.isEmpty){
    //   setState(() {
    //     emailError = 'Email mangler';
    //     passwordError = 'Adgangskode mangler';
    //   });

    // } else if (usernameController.text.isEmpty){
    //   setState(() {
    //     emailError  = 'Email mangler';
    //     passwordError = '';
    //   });

    // }else if(passwordController.text.isEmpty){
    //   setState(() {
    //     emailError = '';
    //     passwordError = 'Adgangskode mangler';
    //   });
    // } else {
    //   setState(() {
    //     emailError = '';
    //     passwordError = '';
    //   });
    // }'x
    try {
      final role = await userService.loginPupil(usernameController.text, passwordController.text);

      // final role = await LoginPagePupil.authService
      //     .fetchAuthData(usernameController.text, passwordController.text);
      
      // final role = UserRoles.of({Role.pupil});

      if (!context.mounted){
        developer.log('buildcontext is not mounted, in $runtimeType');
        return;
      }

      developer.log('Login successful maybeXD?, role data: $role');
      developer.log('Has student role: ${role.hasRole(Role.pupil)}');
      developer.log('Has parent role: ${role.hasRole(Role.guardian)}');
      developer.log('Has teacher role: ${role.hasRole(Role.teacher)}');
      developer.log('Has admin role: ${role.hasRole(Role.admin)}'); 
      // var navStrategy = NavBarStrategyMapper.getNavBarStrategy(role);
      // navStrategy.navigateToHomePage(context, role);
    

      GoRouter.of(context).go(STUDENT_UNLOCKED);
      // if(role.hasRole(Role.pupil)){GoRouter.of(context).go(STUDENT_CREATE);}
      // else if(role.hasRole(Role.guardian)){GoRouter.of(context).go(PARENT_ROOT);}
      // else if(role.hasRole(Role.teacher)){GoRouter.of(context).go(TEACHER_ROOT);}
      // else if(role.hasRole(Role.admin)){GoRouter.of(context).go(ADMIN_ROOT);}
      // else {GoRouter.of(context).go(LOGIN_PAGE);}
    }
    catch (e) {
      if (e is AuthException) {
        handleErrors({'Message': [e.message]});
      } else if (e is NetworkException) {
        if (!context.mounted){
          developer.log('buildcontext is not mounted, in $runtimeType');
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Der opstod et problem ved login: ${e.message}'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 6),
          ),
        );
      } else {
        if (!context.mounted){
          developer.log('buildcontext is not mounted, in $runtimeType');
          return;
        }
        
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Flexible(
              child: Image(
                image: AssetImage('assets/images/logo.png'),
                height: 160,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
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
                          // obscureText: false,
                          controller: usernameController,
                          errorText: emailError
                        ),
                      ),   
                      const SizedBox(height: 50),                
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: 
                        [
                          Text(
                            'Engangskode',
                            style: AppTextStyles.headline4.copyWith(fontSize: 18),
                          ),
                          SizedBox(width: 5),
                          IconButton(icon: SFIcon(SFIcons.sf_info_circle), onPressed: () => 
                            showDialog(context: context, builder: (BuildContext context) {
                              return AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      textAlign: TextAlign.center,
                                      "For at generere en engangskode skal du logge ind som forældre."
                                    ),
                                    SizedBox(height: 15,),
                                    CustomButton(
                                      text: "Ok", 
                                      onTab: () => Navigator.of(context).pop(),
                                      customHeight: customButtonHeight / 2,
                                      customWidth: customButtonHeight 
                                    )
                                  ]
                                ),
                              );
                            })
                          ),
                        ]
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: CustomTextField(
                            hintText: "Engangskode",
                            obscureText: false,
                            controller: passwordController,
                            errorText: passwordError
                          ),
                      ),
                      const SizedBox(height: 25),
          
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 20),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.end,
                      //     children: [
                      //       Flexible(
                      //         child: GestureDetector(
                      //           onTap: () {
                      //             Navigator.push(
                      //               context,
                      //               MaterialPageRoute(
                      //                   builder: (context) =>
                      //                       ForgotPasswordPage()),
                      //             );
                      //           },
                      //           child: Text(
                      //             "Glemt adgangskode?",
                      //             style: AppTextStyles.standard.copyWith(
                      //               color: AppColors.secondary,
                      //               decoration: TextDecoration.underline,
                      //               decorationColor: AppColors.secondary,
                      //               fontSize: 14,
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      const SizedBox(height: 25),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(width: 15),
                        Expanded(
                          child: CustomButton(
                            customHeight: customButtonHeight,
                            text: "Login",
                            onTab: () => signUserIn(context),
                          ),
                        ),
                        // SizedBox(width: 15),
                      ],
                    ),
                    SizedBox(height: 15,),
                    // Expanded(
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: CustomButton(
                          customHeight: customButtonHeight,
                          text: "Login som voksen",
                          onTab: () => Navigator.pop(context)
                        ),
                      ),
                    // ),
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

