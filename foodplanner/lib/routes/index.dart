import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/components/meal.dart';
import 'package:foodplanner/pages/add_ingredient_page.dart';
import 'package:foodplanner/pages/add_meal_page.dart';
import 'package:foodplanner/pages/admin_page.dart';
import 'package:foodplanner/pages/cameraPage.dart';
import 'package:foodplanner/pages/edit_meal_page.dart';
import 'package:foodplanner/pages/forgot_password_page.dart';
import 'package:foodplanner/pages/meal_list_page.dart';
import 'package:foodplanner/pages/parent_page.dart';
import 'package:foodplanner/pages/signup_page.dart';
import 'package:foodplanner/pages/student_page.dart';
import 'package:foodplanner/pages/teacher_page.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:foodplanner/routes/user_roles.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../pages/login_page.dart'; 
import '../pages/unauthorized_page.dart';
import '../pages/home_page.dart'; // Import HomePage

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginPage(),
    ),
     GoRoute(
      path: '/signup',
      builder: (context, state) => SignupPage(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => ForgotPasswordPage(),
    ),
    GoRoute(
      path: AddIngredientPage.routeName,
      builder: (context, state) {
        final mealID = state.pathParameters['meal'] as int;
        if(mealID != null) return AddIngredientPage(mealID: mealID);
        return UnauthorizedPage();
      },
    ),
    GoRoute(
      path: AddMealPage.routeName,
      builder: (context, state) {
        final meal = state.pathParameters['meal'] as Meal;
        if(meal != null) return AddMealPage(meal: meal);
        return UnauthorizedPage();
      },
    ),
    GoRoute(
      path: CameraPage.routeName,
      builder: (context, state) => CameraPage(),
    ),
    GoRoute(
      path: EditMealPage.routeName,
      builder: (context, state) {
        final mealID = state.pathParameters['meal'] as int;
        if(mealID != null) return EditMealPage(mealID: mealID);
        return UnauthorizedPage();
      },
    ),
    GoRoute(
      path: MealListPage.routeName,
      builder: (context, state) => MealListPage(),
    ),


    //no need for wildcard handling as flutter already does it 
   
    
    GoRoute(
      path: TEACHER_ROOT,
      builder: (context, state) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        return authProvider.hasRole(ROLES.teacher) ? const TeacherPage() : const UnauthorizedPage();
      },
    ),
    GoRoute(
      path: STUDENT_ROOT,
      builder: (context, state) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        return authProvider.hasRole(ROLES.student) ? const StudentPage() : const UnauthorizedPage();
      },
    ),
    GoRoute(
      path: ADMIN_ROOT,
      builder: (context, state) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        return authProvider.hasRole(ROLES.admin) ? const AdminPage() : const UnauthorizedPage();
      },
    ),
    GoRoute(
      path: PARENT_ROOT,
      builder: (context, state) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        return authProvider.hasRole(ROLES.parent) ? const ParentPage() : const UnauthorizedPage();
      },
    ),
  ],
);





