import 'package:finetrack/core/theme/app_colors.dart';
import 'package:finetrack/core/theme/app_text_styles.dart';
import 'package:finetrack/core/widgets/custom_button.dart';
import 'package:finetrack/core/widgets/custom_textfield.dart';
import 'package:finetrack/features/auth/screens/register_screen.dart';
import 'package:finetrack/features/auth/services/auth_service.dart';
import 'package:finetrack/features/navigation/screens/main_navigation_screen.dart';
import 'package:finetrack/routes/custom_page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  final AuthService authService = AuthService();

  bool obscurePassword = true;
  bool isLoading = false;

  Future<void> loginUser() async {
    if (emailController.text.trim().isEmpty ||
        passController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await authService.login(
        email: emailController.text.trim(),
        password: passController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        CustomPageRoute(page: const MainNavigationScreen()),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid email or password")),
      );
    } finally {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned(
            top: -120,
            right: -80,
            child: Container(
              height: 250,
              width: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.12),
              ),
            ),
          ),

          Positioned(
            bottom: -100,
            left: -60,
            child: Container(
              height: 220,
              width: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.08),
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 20,
                        spreadRadius: 2,
                        offset: const Offset(0, 10),
                        color: Colors.black.withOpacity(0.08),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.account_balance_wallet_rounded,
                        size: 56,
                        color: AppColors.primary,
                      ).animate().scale(duration: 400.ms),

                      const SizedBox(height: 20),

                      Text(
                        "Welcome Back",
                        style: AppTextStyles.headingLarge,
                      ).animate().fadeIn().slideY(begin: 0.3),

                      const SizedBox(height: 8),

                      Text(
                        "Login to continue managing your finances",
                        style: AppTextStyles.bodySmall,
                      ).animate().fadeIn(delay: 150.ms),

                      const SizedBox(height: 32),

                      CustomTextfield(
                        hintText: "Email Address",
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.email_outlined),
                      ).animate().fadeIn(delay: 250.ms).slideX(begin: 0.2),

                      const SizedBox(height: 20),

                      CustomTextfield(
                        hintText: "Password",
                        controller: passController,
                        obscureText: obscurePassword,
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ).animate().fadeIn(delay: 350.ms).slideX(begin: 0.2),

                      const SizedBox(height: 30),

                      CustomButton(
                        text: "Login",
                        isLoading: isLoading,
                        onPressed: loginUser,
                      ).animate().fadeIn(delay: 450.ms).scale(),

                      const SizedBox(height: 24),

                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: AppTextStyles.bodySmall,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  CustomPageRoute(page: const RegisterScreen()),
                                );
                              },
                              child: const Text("Register"),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 550.ms),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
