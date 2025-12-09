import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/segment_button.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/pages/signup_page_base.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/user_service.dart';
import 'package:go_router/go_router.dart';

class SignupPageAdult extends StatefulWidget {
  static final UserService userService = UserService(apiUrl: ApiConfig.baseUrl);

  const SignupPageAdult({super.key});

  @override 
  State<SignupPageAdult> createState() => _SignupPageAdultState();
}

class _SignupPageAdultState extends State<SignupPageAdult> {

  Set<String> role = {'Parent'};

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

  void roleChange(Set<String> value) {
    setState(() {
      role = value;
    });
  }

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

  void signUserUp(
      BuildContext context,
      String firstName,
      String lastName,
      String email,
      String password,
      Set<String> role) async {

    try {

      final response = await SignupPageBase.userService
          .createUser(firstName, lastName, email, password, role.first);

      if (!context.mounted) return;

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bruger oprettet!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 5),
          ),
        );
      }

      
      GoRouter.of(context).go(UNAUTHORIZED);

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
      buttonText: "Opret mig", 
      selection: roleSelection(), 
      onSubmit: (fields) async {
        signUserUp(context, 
          fields["firstName"]!, 
          fields["lastName"]!,
          fields["email"]!,
          fields["password"]!,
          role
        );
      }
    );
  }

}
