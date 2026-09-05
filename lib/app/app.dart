import 'package:flutter/material.dart';
import 'package:glance/app/app_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
    );
  }
}