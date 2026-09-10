import 'package:flutter/material.dart';
import 'package:glance/core/theme/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: AppColors.charcoal,
      body: Center(
        child: Text('Glance',style: TextTheme.of(context).displayLarge,),
      ),
    );
  }
}