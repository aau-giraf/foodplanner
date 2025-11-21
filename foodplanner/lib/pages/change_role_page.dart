import 'package:flutter/material.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/models/user_roles.dart';
import 'package:foodplanner/pages/main_page_admin.dart';
import 'package:foodplanner/pages/main_page_admin_teacher.dart';
import 'package:foodplanner/pages/main_page_parent.dart';
import 'package:foodplanner/pages/main_page_teacher.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:foodplanner/services/active_role_service.dart';
import 'package:go_router/go_router.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/components/nav_bar.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/models/user.dart'; // as model;
import 'package:foodplanner/services/user_service.dart';
import 'package:provider/provider.dart';


class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({super.key});

  static final UserService userService = UserService(apiUrl: ApiConfig.baseUrl);

  @override
  State<RoleSelectionPage> createState() => _SelectionPageRoleState();
}

class _SelectionPageRoleState extends State<RoleSelectionPage> {
  List<Map<String, String?>> students = [];
  List<Map<String, String?>> filteredStudents = [];
  List<Map<String, String>> schoolClasses = [];
  Set<String> selectedClassIds = {};
  Set<String> highlightedStudentIds = {};
  TextEditingController searchController = TextEditingController();

  String? _selectedRole;

  Future<void> _selectRole(String role) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    await auth.setRole(role as UserRoles);
    await auth.loadFromStorage();
    setState(() => _selectedRole = role);
  }
  /*
  Future<void> fetchUser() async {
    final userInfo = await RoleSelectionPage.userService.fetchLoggedInUser();
    setState(() {
      admin = userInfo;
    });
  }
  */
  /*
  model.User admin = model.User(
      id: 0,
      email: 'Unknown',
      firstName: 'Unknown',
      lastName: 'Unknown',
      role: UserRoles.Unknown,
      archived: false);
    */
  
  /*@override
  void initState() {
    super.initState();
    fetchUser();
  }*/

  List<Map<String, dynamic>> get adminActions  => [
        {
          'title': "Admin",
          'height': 100,
          'fontSize': 35,
          'cta': Row(
            mainAxisSize: MainAxisSize.min,
          ),
          'ctaFunction': () {
            ActiveRoleService.setActiveRole(Role.admin); 
            context.go(ADMIN_ROOT);
            /*Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AdminLandingPage()),
            );*/
          }
        },
        {
          'title': "Lærer",
          'height': 100,
          'fontSize': 35,
          'cta': Row(
            mainAxisSize: MainAxisSize.min,
          ),
          'ctaFunction': () {
            ActiveRoleService.setActiveRole(Role.teacher);
            context.go(ADMIN_TEACHER_ROOT);
            /*Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TeacherMainPage()),
            );*/
          }
        },
        {
          'title': "Log ud",
          'height': 60,
          'borderRadius': BorderRadius.circular(50),
          'cta': Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.logout),
              SizedBox(width: 10),
            ],
          ),
          'ctaFunction': () async {
            final auth = Provider.of<AuthProvider>(context, listen: false);
            await auth.logout(); 
            GoRouter.of(context).go('/');
          }
        },
      ];

    @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        toolbarHeight: 225,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 70),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
          
          Text(
            'Velkommen!',
            style: TextStyle(fontSize: 36),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5),
          Text(
              'Fortsæt som...',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
          ),
          ],
          ),
        )
      ),
      backgroundColor: Colors.white,

      bottomNavigationBar: NavBar(),
      body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                ...adminActions.map((action) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: GestureDetector(
                      onTap: action['ctaFunction'] as VoidCallback?,
                      child: Container(
                        width: double.infinity,
                        height: action['height'] as double? ?? 60,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: action['borderRadius'] as BorderRadius ?
                          ?? const BorderRadius.vertical(
                            top: Radius.circular(20),
                            bottom: Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x3F000000),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(
                              action['title'] as String,
                              style: TextStyle(
                                fontSize: action['fontSize'] as double? ?? 20,                                )
                            ),
                            Positioned(
                              right: 0,
                              child: action['cta'] as Widget,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      );
  }
}