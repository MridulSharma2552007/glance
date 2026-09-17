import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:flutter/material.dart';
import 'package:glance/core/supabase/supabase_internals.dart';
import 'package:glance/core/theme/app_colors.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:glance/core/storage/storage_services.dart';
import 'package:glance/core/storage/storage_keys.dart';
import 'package:go_router/go_router.dart';

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
                onTap: () async {
                  final success = await SupabaseInternals().googleSignIn();

                  if (success) {
                    DelightToastBar(
                      builder: (context) => const ToastCard(
                        leading: Icon(
                          Icons.check_circle,
                          size: 28,
                          color: Colors.green,
                        ),
                        title: Text(
                          "Signed in successfully",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ).show(context);

                    final role = StorageServices.getString(StorageKeys.userrole);

                    if (role == 'Student') {
                      context.pushReplacementNamed('student_registration');
                    } else if (role == 'Teacher') {
                      context.pushReplacementNamed('teacher_registration');
                    } else {
                      context.pushReplacementNamed('role_selection');
                    }
                  } else {
                    DelightToastBar(
                      builder: (context) => const ToastCard(
                        leading: Icon(
                          Icons.error,
                          size: 28,
                          color: Colors.red,
                        ),
                        title: Text(
                          "Sign in failed",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ).show(context);
                  }
                },
                borderRadius: BorderRadius.circular(18),
                child: Ink(
                  height: 72,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.cream,
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