// main root and auth root
import 'package:foodplanner/pages/add_ingredient_page.dart';
import 'package:foodplanner/pages/add_meal_page.dart';
import 'package:foodplanner/pages/cameraPage.dart';
import 'package:foodplanner/pages/edit_meal_page.dart';
import 'package:foodplanner/pages/meal_list_page.dart';

const String MAIN_ROOT = '/';
const String ADMIN_ROOT = '/admin';
const String TEACHER_ROOT = '/teacher';
const String STUDENT_ROOT = '/student';
const String PARENT_ROOT = '/parent';

// additional pages
const String MAIN_PAGE = '/home';
const String LOGIN_PAGE = '/login';
const String SIGNUP_PAGE = '/signup';
const String ADD_INGREDIENT_PAGE = AddIngredientPage.routeName;
const String ADD_MEAL_PAGE = AddMealPage.routeName;
const String CAMERA_PAGE = CameraPage.routeName;
const String EDIT_MEAL_PAGE = EditMealPage.routeName;
const String MEAL_LIST_PAGE = MealListPage.routeName;

// routing through concat of pages from above (lavet baseret på vores p3 dont ask why)
const String MAIN_PAGE_ROUTE = MAIN_PAGE;
const String TEACHER_HOME_ROUTE = '$TEACHER_ROOT$MAIN_PAGE';
// const String LOGIN_PAGE_ROUTE = '$AUTH_ROOT$LOGIN_PAGE'; // keeping comment to see how to concat



