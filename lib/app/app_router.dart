
import 'package:glance/app/feature/signups/select_role_screen.dart';
import 'package:glance/app/feature/signups/signin_screen.dart';
import 'package:glance/app/feature/signups/student_registration.dart';
import 'package:glance/app/feature/signups/teacher_registration.dart';
import 'package:glance/app/feature/splash/splash_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final router=GoRouter(routes: [
    GoRoute(path: '/',builder: (context, state) => SplashScreen(),),
    GoRoute(
      path: '/role_selection',
      name: 'role_selection',
      builder: (context, state) => SelectRoleScreen(),
    ),
    GoRoute(path: '/signin', builder: (context, state) => SigninScreen(), name: 'signin'),
    GoRoute(
      path: '/student_registration',
      name: 'student_registration',
      builder: (context, state) => const StudentRegistrationScreen(),
    ),
    GoRoute(
      path: '/teacher_registration',
      name: 'teacher_registration',
      builder: (context, state) => const TeacherRegistrationScreen(),
    ),
  ]);
}
