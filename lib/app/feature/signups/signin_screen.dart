import 'package:flutter/material.dart';
import 'package:glance/core/theme/app_colors.dart';
import 'package:glance/core/theme/text_theme.dart';

class SigninScreen extends StatelessWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: PageView(children: [RoleSelectionScreen()]),
    );
  }
}

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40),
          Text('Glance', style: AppTypography.textTheme.headlineLarge),
          SizedBox(height: 60),

          Text(
            "Who's joining \ntoday?",
            style: AppTypography.textTheme.headlineLarge,
          ),
          SizedBox(height: 10),
          Text(
            "We'll tailor the app to what you \n need to do.",
            style: TextStyle(color: AppColors.inkSoft, fontSize: 22),
          ),

          SizedBox(height: 60),
         RoleSelectionWidget(role:'Student', rolelabel: 'Scan in, track \n attendance', tileColor:AppColors.lavSoft),
         SizedBox(height: 40,),
         RoleSelectionWidget(role: 'Teacher', rolelabel: 'Start class, watch it fill \n up', tileColor:AppColors.roseSoft)
        ],
      ),
    );
  }
}

class RoleSelectionWidget extends StatefulWidget {
  final String role;
  final String rolelabel;
  final Color tileColor;
  const RoleSelectionWidget({
    super.key,
    required this.role,
    required this.rolelabel,
    required this.tileColor,
  });

  @override
  State<RoleSelectionWidget> createState() => _RoleSelectionWidgetState();
}

class _RoleSelectionWidgetState extends State<RoleSelectionWidget> {
  bool _pressed = false;

  void _onTapDown(_) => setState(() => _pressed = true);
  void _onTapUp(_) => setState(() => _pressed = false);
  void _onTapCancel() => setState(() => _pressed = false);

  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsets.all(_pressed ? 16 : 20);
    final scale = _pressed ? 0.985 : 1.0;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: () {
        // keep visual feedback only; hook action here if needed
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        padding: padding,
        transform: Matrix4.identity()..scale(scale, scale),
        decoration: BoxDecoration(
          color: widget.tileColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.role,
                  style: AppTypography.textTheme.headlineMedium,
                ),
                SizedBox(height: 15),
                Text(
                  widget.rolelabel,
                  style: AppTypography.textTheme.bodySmall,
                ),
              ],
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              curve: Curves.easeOut,
              height: _pressed ? 46 : 50,
              width: _pressed ? 46 : 50,
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Icon(Icons.arrow_forward_ios_rounded),
            )
          ],
        ),
      ),
    );
  }
}
