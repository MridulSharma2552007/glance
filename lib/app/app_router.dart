
import 'package:glance/app/feature/splash/splash_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final router=GoRouter(routes: [
    GoRoute(path: '/',builder: (context, state) => SplashScreen(),)
  ]);
}
