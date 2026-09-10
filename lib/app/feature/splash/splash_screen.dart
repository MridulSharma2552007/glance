import 'package:flutter/material.dart';
import 'package:glance/core/theme/app_colors.dart';
import 'package:glance/core/theme/text_theme.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
   Future.delayed(Duration(seconds: 2),(){
    context.pushReplacementNamed('signin');
   });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: AppColors.charcoal,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Glance',
              style:AppTypography.textTheme.displayLarge
            ),
            Text('attendance, without the roll call',style: AppTypography.textTheme.bodyMedium,)
          ],
        ),
      ),
    );
  }
}