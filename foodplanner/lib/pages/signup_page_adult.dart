import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/segment_button.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/pages/login_page.dart';
import 'package:foodplanner/pages/signup_page_base.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:foodplanner/routes/user_roles.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/fetch_auth.dart';
import 'package:foodplanner/services/user_service.dart';
import 'package:go_router/go_router.dart';

class SignupPageAdult extends StatefulWidget {
  static final UserService userService = UserService(apiUrl: ApiConfig.baseUrl);

  const SignupPageAdult({super.key});

  @override 
  State<SignupPageAdult> createState() => _SignupPageAdultState();
}

class _SignupPageAdultState extends State<SignupPageAdult> {

  Widget roleSelection(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Jeg er',
          style: AppTextStyles.bigText.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomSegmentButton(
            buttonSegments: segments,
            selected: role,
            onTab: roleChange,
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }

  List<ButtonSegment<String>> segments = [
    ButtonSegment(
      value: 'Parent',
      label: Text('Forældre'),
      icon: SFIcon(SFIcons.sf_figure_and_child_holdinghands),
    ),
    ButtonSegment(
      value: 'Teacher',
      label: Text('Lærer'),
      icon: SFIcon(SFIcons.sf_graduationcap_fill),
    ),
  ];

  Set<String> role = {'Parent'};

  void roleChange(Set<String> value) {
    setState(() {
      role = value;
    });
  }


void signUserUp(
      BuildContext context,
      String firstName,
      String lastName,
      String email,
      String password,
      String role) async {

    try {

      final response = await SignupPageBase.userService
          .createUser(firstName, lastName, email, password, role);

      if (!context.mounted) return;

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bruger oprettet!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 5),
          ),
        );

        try {
          final role =
              await LoginPage.authService.fetchAuthData(email, password);
          switch (role) {
            case ROLES.student:
              GoRouter.of(context).go(STUDENT_CREATE);
              break;
            default:
              GoRouter.of(context).go(UNAUTHORIZED);
              break;
          }
        } catch (e) {
          if (e is AuthException) {
            (context as Element).findAncestorStateOfType<SignupPageBaseState>()?.handleErrors({'Message': [e.message]});
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Fejl ved login af bruger: ${e.message}'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 5),
              ),
            );
          } else {
            if (role == 'Parent') {
              context.go('/signup/create-child');
            } else {
              context.go('/');
            }
          }
        }
      } else {
        var error = jsonDecode(response.body);
        (context as Element).findAncestorStateOfType<SignupPageBaseState>()?.handleErrors(error);
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fejl ved oprettelse af bruger: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context){
    return SignupPageBase(
      title: "Opret mig", 
      buttonText: "Opret mit", 
      selection: roleSelection(), 
      onSubmit: (fields) async {
        signUserUp(context, 
          fields["firstName"]!, 
          fields["lastName"]!,
          fields["email"]!,
          fields["password"]!,
          fields["role"]!
        );
      }
    );
  }

}
