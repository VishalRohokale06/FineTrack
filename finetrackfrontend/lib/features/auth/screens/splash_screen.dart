import 'package:finetrack/core/theme/app_colors.dart';
import 'package:finetrack/core/theme/app_text_styles.dart';
import 'package:finetrack/features/auth/screens/login_screen.dart';
import 'package:finetrack/features/auth/services/auth_service.dart';
import 'package:finetrack/features/navigation/screens/main_navigation_screen.dart';
import 'package:finetrack/routes/custom_page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    final token = await authService.getToken();

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        CustomPageRoute(page: const MainNavigationScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        CustomPageRoute(page: const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned(
            top: -140,
            right: -100,
            child: Container(
              height: 280,
              width: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.12),
              ),
            ),
          ),

          Positioned(
            bottom: -120,
            left: -90,
            child: Container(
              height: 250,
              width: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.08),
              ),
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 25,
                            spreadRadius: 3,
                            offset: const Offset(0, 12),
                            color: AppColors.primary.withOpacity(0.25),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet_rounded,
                        size: 60,
                        color: Colors.white,
                      ),
                    )
                    .animate()
                    .scale(duration: 800.ms, curve: Curves.easeOutBack)
                    .fadeIn(),

                const SizedBox(height: 28),

                Text(
                  "FinTrack",
                  style: AppTextStyles.headingLarge,
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.4),

                const SizedBox(height: 8),

                Text(
                  "Smart Expense Management",
                  style: AppTextStyles.bodySmall,
                ).animate().fadeIn(delay: 350.ms),

                const SizedBox(height: 50),

                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 12,
                        color: Colors.black.withOpacity(0.06),
                      ),
                    ],
                  ),
                  child: const SizedBox(
                    height: 26,
                    width: 26,
                    child: CircularProgressIndicator.adaptive(strokeWidth: 2.5),
                  ),
                ).animate().fadeIn(delay: 500.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
