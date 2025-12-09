// main root and auth root

const String MAIN_ROOT = '/';
const String ADMIN_ROLES_ROOT = '/admin_roles';
const String ADMIN_ROOT = '/admin';
const String ADMIN_TEACHER_ROOT = '/admin_teacher';
const String TEACHER_ROOT = '/teacher';
const String PUPIL_ROOT = '/pupil';
const String GUARDIAN_ROOT = '/guardian';
const String UNAUTHORIZED = '/unauthorized';

// additional pages
const String MAIN_PAGE = '/home';
const String LOGIN_PAGE = '/login';
const String SIGNUP_PAGE = '/signup';
const String MADPAKKE = '/madpakke';
const String CREATE = '/create';
const String PROFILE_PAGE = '/profile';
const String SETTINGS_PAGE = '/settings';
const String FEEDBACK_PAGE = '/feedbackPage';
const String ADD_MEAL = '/create';
const String EDIT_MEAL = '/edit';
const String NO_MEAL = '/empty';
//const String GUARDIAN_MAIN = '/guardian_landing_page';
const String PUPIL_UNLOCKED = "/pupil_unlocked";
const String CHOOSE_PUPIL_GUARDIAN = '/choose_pupil_guardian';
const String CHOOSE_PUPIL_TEACHER = '/choose_pupil_teacher';
const String ADMIN_PROFILES_PAGE = '/admin_profiles_page';
const String ADMIN_SCHOOL = '/admin_school';

// routing through concat of pages from above (lavet baseret på vores p3 dont ask why)
const String MAIN_PAGE_ROUTE = MAIN_PAGE;
const String TEACHER_HOME_ROUTE = '$TEACHER_ROOT$MAIN_PAGE';
const String PARENT_MADPAKKE = '$GUARDIAN_ROOT$MADPAKKE';
// const String LOGIN_PAGE_ROUTE = '$AUTH_ROOT$LOGIN_PAGE'; // keeping comment to see how to concat
const String STUDENT_CREATE = '$PUPIL_ROOT$CREATE';
