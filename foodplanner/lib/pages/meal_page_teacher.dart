import 'package:flutter/material.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/mealBox.dart';
import 'package:foodplanner/models/child.dart';
import 'package:foodplanner/pages/pin_code.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:foodplanner/routes/user_roles.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/child_service.dart';
import 'package:foodplanner/services/user_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';


class TeacherMealPage extends StatefulWidget {
  final Map<String, String> student;
  const TeacherMealPage({super.key, /* required Map<String, String> */ required this.student});

  @override
  _TeacherMealPageState createState() => _TeacherMealPageState();
}


class _TeacherMealPageState extends State<TeacherMealPage> {
  late Future<bool> _hasRolesFuture;
  Child? _child;
  final ChildService childService = ChildService(apiUrl: ApiConfig.baseUrl);

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.loadFromStorage().then((_){
      authProvider.retrieveToken().then((token){
        
        setState(() {
          _hasRolesFuture = authProvider.hasRoles([ROLES.parent, ROLES.student]);
          if (authProvider.userRole == ROLES.student || authProvider.userRole == ROLES.parent) {
            childService.fetchChildById().then((childData) {
              setState(() {
                _child = childData;
                print(_child!.firstName);
              });
            });
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    

    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: size.width * 0.9,  
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Velkommen ${_child != null ? '${_child?.firstName} ${_child?.lastName}' : widget.student['name']}',
                          
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: size.height * 0.05),
                        ReusableMealBox(size: size),
                        SizedBox(height: size.height * 0.02),

                        CustomButton(
                            onTab: () {
                              GoRouter.of(context).go(FEEDBACK_Page, extra: {'from': TEACHER_ROOT, 'childId': _child?.childId});;
                            }, 
                            text: 'Se Feedback',
                            //fontSize: 16,
                            customWidth: size.width * 0.6,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          FutureBuilder<bool>(
            future: authProvider.hasRoles([ROLES.parent, ROLES.student]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox.shrink(); // Show nothing while waiting
              } else if (snapshot.hasData && snapshot.data == true) {
                return Positioned(
                  top: -8,
                  right: 30,
                  child: IconButton(
                    icon: Icon(Icons.lock_outline, size: 40, color: Colors.black),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PinCode()),
                      );  
                    },
                  ),
                );
                
              } else {
                return SizedBox.shrink(); // Show nothing if the user does not have the roles
              }
            },
          ),
        ],
      ),
    );
  }
}