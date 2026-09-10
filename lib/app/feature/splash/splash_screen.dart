import 'dart:async';

import 'package:flutter/material.dart';
import 'package:glance/core/theme/app_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:glance/core/config/config.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  String? _userId;

@override
  void initState() {
    super.initState();
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.amberSoft,

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        
          children: [
          Text(_userId ?? ''),
          ElevatedButton(
            onPressed: () async {
              try {
               
              } catch (e) {
                debugPrint('Google sign-in failed: $e');
                print(e);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Sign in failed: ${e.toString()}')),
                  );
                }
              }
            },
            child: Text('SIGN IN'),
          )
        ],
            ),
      ),
    );
  }
}
