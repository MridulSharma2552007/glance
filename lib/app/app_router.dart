
import 'package:glance/app/feature/signups/select_role_screen.dart';
import 'package:glance/app/feature/signups/signin_screen.dart';
import 'package:glance/app/feature/splash/splash_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final router=GoRouter(routes: [
    GoRoute(path: '/',builder: (context, state) => SplashScreen(),),
    GoRoute(path: '/role_selection',
    name: 'role_selection',
    builder: (context, state) => SelectRoleScreen(),),
    GoRoute(path: '/signin',builder: (context, state) => SigninScreen(),)
  ]);
}
