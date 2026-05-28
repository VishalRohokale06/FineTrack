import 'package:finetrack/core/provider/theme_provider.dart';
import 'package:finetrack/core/theme/app_text_styles.dart';
import 'package:finetrack/core/widgets/app_snackbar.dart';
import 'package:finetrack/features/auth/screens/login_screen.dart';
import 'package:finetrack/features/auth/services/auth_service.dart';
import 'package:finetrack/routes/custom_page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../widgets/profile_header.dart';
import '../../recurring/screens/recurring_expense_screen.dart';
import '../widgets/settings_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> showLogoutDialog(BuildContext context) async {
    final authService = AuthService();

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: AppColors.surface,
            title: const Text("Logout"),
            content: const Text("Are you sure you want to logout?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),

              TextButton(
                onPressed: () async {
                  Navigator.pop(context);

                  await authService.logout();

                  if (!context.mounted) return;

                  Navigator.pushAndRemoveUntil(
                    context,
                    CustomPageRoute(page: const LoginScreen()),
                    (route) => false,
                  );

                  AppSnackbar.show(context, "Logged out successfully");
                },
                child: const Text("Logout"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProfileHeader()
                .animate()
                .fadeIn(duration: 300.ms)
                .slideY(begin: 0.2),

            const SizedBox(height: 30),

            Text(
              "Account",
              style: AppTextStyles.headingSmall,
            ).animate().fadeIn(delay: 100.ms),

            const SizedBox(height: 16),

            SettingsTile(
              icon: Icons.person_outline,
              title: "Edit Profile",
              onTap: () {
                AppSnackbar.show(context, "Edit Profile clicked");
              },
            ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.2),

            SettingsTile(
              icon: Icons.lock_outline,
              title: "Change Password",
              onTap: () {
                AppSnackbar.show(context, "Change Password clicked");
              },
            ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.2),

            SettingsTile(
              icon: Icons.repeat,
              title: "Recurring Expenses",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RecurringExpenseScreen(),
                  ),
                );
              },
            ),

            SettingsTile(
              icon: Icons.notifications_outlined,
              title: "Notifications",
              onTap: () {
                AppSnackbar.show(context, "Notifications clicked");
              },
            ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.2),

            const SizedBox(height: 30),

            Text(
              "App Settings",
              style: AppTextStyles.headingSmall,
            ).animate().fadeIn(delay: 500.ms),

            const SizedBox(height: 16),

            SettingsTile(
              icon: Icons.dark_mode_outlined,
              title: "Theme",
              onTap: () {
                showThemeDialog(context);
              },
            ).animate().fadeIn(delay: 600.ms).slideX(begin: 0.2),

            SettingsTile(
              icon: Icons.help_outline,
              title: "Help & Support",
              onTap: () {
                AppSnackbar.show(context, "Help clicked");
              },
            ).animate().fadeIn(delay: 700.ms).slideX(begin: 0.2),

            SettingsTile(
              icon: Icons.info_outline,
              title: "About App",
              onTap: () {
                AppSnackbar.show(context, "FinTrack v1.0");
              },
            ).animate().fadeIn(delay: 800.ms).slideX(begin: 0.2),

            const SizedBox(height: 40),

            CustomButton(
              text: "Logout",
              onPressed: () {
                showLogoutDialog(context);
              },
            ).animate().fadeIn(delay: 900.ms).scale(),
          ],
        ),
      ),
    );
  }

  void showThemeDialog(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Choose Theme"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.light_mode),
                  title: const Text("Light"),
                  onTap: () async {
                    await themeProvider.setTheme(ThemeMode.light);

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.dark_mode),
                  title: const Text("Dark"),
                  onTap: () async {
                    await themeProvider.setTheme(ThemeMode.dark);

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.phone_android),
                  title: const Text("System Default"),
                  onTap: () async {
                    await themeProvider.setTheme(ThemeMode.system);

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
    );
  }
}
