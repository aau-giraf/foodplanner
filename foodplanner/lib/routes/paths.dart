// main root and auth root
const String MAIN_ROOT = '/';
const String ADMIN_ROOT = '/admin';
const String TEACHER_ROOT = '/teacher';
const String STUDENT_ROOT = '/student';

// additional pages
const String MAIN_PAGE = '/home';
const String LOGIN_PAGE = '/login';
const String SIGNUP_PAGE = '/signup';


// routing through concat of pages from above (lavet baseret på vores p3 dont ask why)
const String MAIN_PAGE_ROUTE = MAIN_PAGE;
const String TEACHER_HOME_ROUTE = '$TEACHER_ROOT$MAIN_PAGE';
// const String LOGIN_PAGE_ROUTE = '$AUTH_ROOT$LOGIN_PAGE'; // keeping comment to see how to concat



