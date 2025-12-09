import 'package:flutter/material.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/models/user_roles.dart';
import 'package:foodplanner/navigation/navbar_strategy_mapper.dart';
import 'package:foodplanner/navigation/navigation_strategy.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:foodplanner/services/active_role_service.dart';
import 'package:go_router/go_router.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/components/nav_bar.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/models/user.dart' as model;
import 'package:foodplanner/services/user_service.dart';
import 'package:provider/provider.dart';

class AdminLandingPage extends StatefulWidget {
  const AdminLandingPage({super.key});

  static final UserService userService = UserService(apiUrl: ApiConfig.baseUrl);

  @override
  State<AdminLandingPage> createState() => _LandingPageAdminState();
}

class _LandingPageAdminState extends State<AdminLandingPage> {
  List<Map<String, String?>> students = [];
  List<Map<String, String?>> filteredStudents = [];
  List<Map<String, String>> schoolClasses = [];
  Set<String> selectedClassIds = {};
  Set<String> highlightedStudentIds = {};
  TextEditingController searchController = TextEditingController();

  NavigationStrategy? navStrategy; 

  Future<void> fetchUser() async {
    final userInfo = await AdminLandingPage.userService.fetchLoggedInUser();
    setState(() {
      admin = userInfo;
      navStrategy = NavBarStrategyMapper.getNavBarStrategy(userInfo.role);
      debugPrint('navStrategy $navStrategy');
    });
  }
  model.User admin = model.User(
      id: 0,
      email: 'Unknown',
      firstName: 'Unknown',
      lastName: 'Unknown',
      role: UserRoles.empty(),
      archived: false);

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  List<Map<String, dynamic>> get adminActions  => [
        {
          'title': "Administrér Profiler",
          'cta': Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.manage_accounts),
              SizedBox(width: 10),
            ],
          ),
          'ctaFunction': () {
            navStrategy?.goToPage(ADMIN_PROFILES_PAGE, context);
          }
        },
        {
          'title': "Administrér Skole",
          'cta': Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.school),
              SizedBox(width: 10),
            ],
          ),
          'ctaFunction': () {
            navStrategy?.goToPage(ADMIN_SCHOOL, context);
          }
        },
        {
          'title': "Indstillinger",
          'cta': Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.settings),
              SizedBox(width: 10),
            ],
          ),
          'ctaFunction': () {
            navStrategy?.goToPage(SETTINGS_PAGE, context);
          }
        },
        {
          'title': "Skift Rolle",
          'cta': Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.group),
              SizedBox(width: 10),
            ],
          ),
          'ctaFunction': () {
            ActiveRoleService.setActiveRole(Role.teacher);
            navStrategy = NavBarStrategyMapper.getNavBarStrategy(admin.role);
            navStrategy?.goToPage(ADMIN_TEACHER_ROOT, context);
           
          }
        },
        {
          'title': "Log ud",
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
            if(!mounted) {
              return;
            }
            GoRouter.of(context).go('/');
            ActiveRoleService.setActiveRole(null);
          }
        },
      ];

    @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 225,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 70),
          child: Text(
            'Velkommen \n${admin.firstName}',
            style: TextStyle(fontSize: 36),
            textAlign: TextAlign.center,
          )
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
                        height: 60,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(50),
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
                              style: TextStyle(fontSize: 20)
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