import 'package:flutter/material.dart';
import 'package:glance/core/theme/app_colors.dart';

class SigninScreen extends StatelessWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AppColors.charcoal,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40,horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Sign in. \n That's it.",style: TextStyle(color: AppColors.cream,fontSize: 50,fontWeight: FontWeight.bold)),
            SizedBox(height: 20,),
            Text("Google confirms it's you. \nSupabase quietly handles the rest \n — new account or old.",style: TextStyle(color: AppColors.inkSoft, fontSize: 18),),
            const Spacer(),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(18),
                child: Ink(
                  height: 72,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/pngwing.com.png',
                          width: 26,
                          height: 26,
                        ),
                        const Expanded(
                          child: Center(
                            child: Text(
                              'Sign in with Google',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}